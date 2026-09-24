def hash_password(password: str) -> str:
    """TODO: hash [password]."""
    raise NotImplementedError


def verify_password(password: str, password_hash: str) -> bool:
    """TODO: check [password] against [password_hash]."""
    raise NotImplementedError


def create_access_token(subject: str) -> str:
    """TODO: issue a JWT for [subject]."""
    raise NotImplementedError


def decode_access_token(token: str) -> dict[str, str]:
    """TODO: validate [token] and return its claims."""
    raise NotImplementedError
