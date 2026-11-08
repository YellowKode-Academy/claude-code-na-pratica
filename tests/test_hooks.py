"""Roda os dois hooks de PreToolUse contra repositórios git descartáveis.

Cada teste manda ao hook o mesmo JSON que o Claude Code manda no stdin e
confere o código de saída: 0 deixa a chamada Bash passar, 2 bloqueia.
"""
import json
import shutil
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent
MAIN_HOOK = ROOT / ".claude" / "hooks" / "block-main-commit.sh"
SECRETS_HOOK = ROOT / "security-review-plugin" / "hooks" / "block-secrets-commit.sh"
BASH = shutil.which("bash")

pytestmark = pytest.mark.skipif(BASH is None, reason="bash não está disponível")

# Montada em tempo de execução para este arquivo nunca conter algo com cara de secret.
FAKE_KEY = "sk-" + "a1b2c3d4" * 3


def git(repo, *args):
    subprocess.run(["git", "-C", str(repo), *args], check=True, capture_output=True)


@pytest.fixture
def repo(tmp_path):
    git(tmp_path, "init", "-q", "-b", "main")
    git(tmp_path, "config", "user.email", "test@example.com")
    git(tmp_path, "config", "user.name", "Test")
    (tmp_path / "app.py").write_text("x = 1\n")
    git(tmp_path, "add", "app.py")
    git(tmp_path, "commit", "-q", "-m", "init")
    return tmp_path


def run_hook(hook, repo, command=None, raw=None):
    stdin = raw if raw is not None else json.dumps(
        {"tool_name": "Bash", "tool_input": {"command": command}}
    )
    return subprocess.run(
        [BASH, str(hook)], input=stdin, text=True, cwd=repo, capture_output=True
    ).returncode


@pytest.mark.parametrize("command", [
    'git commit -m "fix"',
    'git commit -am "fix"',
    'git add . && git commit -m "fix"',
    'git -C . commit -m "fix"',
])
def test_main_hook_blocks_commits_on_main(repo, command):
    assert run_hook(MAIN_HOOK, repo, command) == 2


@pytest.mark.parametrize("command", ["git status", "pytest tests/", "git log --grep commit"])
def test_main_hook_lets_other_commands_through(repo, command):
    assert run_hook(MAIN_HOOK, repo, command) == 0


def test_main_hook_allows_commit_on_a_work_branch(repo):
    git(repo, "checkout", "-q", "-b", "feature/x")
    assert run_hook(MAIN_HOOK, repo, 'git commit -am "fix"') == 0


@pytest.mark.parametrize("hook", [MAIN_HOOK, SECRETS_HOOK])
def test_hooks_fail_closed_on_unreadable_input(repo, hook):
    assert run_hook(hook, repo, raw="not json") == 2


def test_secrets_hook_blocks_a_staged_secret(repo):
    (repo / "config.py").write_text(f'KEY = "{FAKE_KEY}"\n')
    git(repo, "add", "config.py")
    assert run_hook(SECRETS_HOOK, repo, 'git commit -m "config"') == 2


def test_secrets_hook_sees_unstaged_changes_with_commit_a(repo):
    (repo / "app.py").write_text(f'KEY = "{FAKE_KEY}"\n')
    assert run_hook(SECRETS_HOOK, repo, 'git commit -am "config"') == 2


def test_secrets_hook_lets_a_clean_commit_through(repo):
    (repo / "app.py").write_text("x = 2\n")
    assert run_hook(SECRETS_HOOK, repo, 'git commit -am "bump"') == 0
