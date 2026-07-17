import pytest
from src.pr_validator import validate_pr_title, validate_pr_size, touches_sensitive_area


class TestValidatePrTitle:
    def test_rejects_empty_string(self):
        with pytest.raises(ValueError):
            validate_pr_title("")

    def test_rejects_whitespace_only(self):
        with pytest.raises(ValueError):
            validate_pr_title("   ")

    def test_accepts_valid_title(self):
        assert validate_pr_title("feat: add new endpoint") is True

    def test_accepts_conventional_commit_format(self):
        assert validate_pr_title("fix: corrige validacao de token") is True


class TestValidatePrSize:
    def test_accepts_small_pr(self):
        assert validate_pr_size(50) is True

    def test_accepts_pr_at_limit(self):
        assert validate_pr_size(200) is True

    def test_rejects_pr_above_limit(self):
        with pytest.raises(ValueError):
            validate_pr_size(201)

    def test_custom_limit(self):
        with pytest.raises(ValueError):
            validate_pr_size(101, max_lines=100)


class TestTouchesSensitiveArea:
    def test_detects_auth_files(self):
        assert touches_sensitive_area(["auth/tokens.py", "src/main.py"]) is True

    def test_detects_billing_files(self):
        assert touches_sensitive_area(["billing/invoice.py"]) is True

    def test_returns_false_for_safe_files(self):
        assert touches_sensitive_area(["src/main.py", "tests/test_main.py"]) is False

    def test_empty_list_is_safe(self):
        assert touches_sensitive_area([]) is False
