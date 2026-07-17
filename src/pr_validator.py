"""Validador de Pull Requests para o revisor autônomo."""


def validate_pr_title(title: str) -> bool:
    """Valida que o título do PR não é vazio após strip."""
    if not title.strip():
        raise ValueError("Título não pode ser vazio")
    return True


def validate_pr_size(diff_lines: int, max_lines: int = 200) -> bool:
    """Valida que o PR não ultrapassa o limite de linhas para aprovação automática."""
    if diff_lines > max_lines:
        raise ValueError(f"PR muito grande para aprovação automática ({diff_lines} linhas, limite {max_lines})")
    return True


def touches_sensitive_area(changed_files: list[str]) -> bool:
    """Retorna True se algum arquivo alterado pertence a área sensível (auth/ ou billing/)."""
    sensitive = ("auth/", "billing/")
    return any(f.startswith(sensitive) for f in changed_files)
