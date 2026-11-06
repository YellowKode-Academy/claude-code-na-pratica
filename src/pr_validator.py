"""Pull Request validator for the autonomous reviewer."""


def validate_pr_title(title: str) -> bool:
    """Validates that the PR title is not empty after strip."""
    if not title.strip():
        raise ValueError("Title cannot be empty")
    return True


def validate_pr_size(diff_lines: int, max_lines: int = 200) -> bool:
    """Validates that the PR does not exceed the line limit for automatic approval."""
    if diff_lines > max_lines:
        raise ValueError(f"PR too large for automatic approval ({diff_lines} lines, limit {max_lines})")
    return True


def touches_sensitive_area(changed_files: list[str]) -> bool:
    """Returns True if any changed file belongs to a sensitive area (auth/ or billing/)."""
    sensitive = ("auth/", "billing/")
    return any(f.startswith(sensitive) for f in changed_files)
