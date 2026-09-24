from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="GAMIAI_")

    app_name: str = "GamiAI"
    database_url: str = "postgresql+psycopg://gamiai:gamiai@localhost:5432/gamiai"
    redis_url: str = "redis://localhost:6379/0"
    jwt_secret: str = "change-me"


def get_settings() -> Settings:
    return Settings()
