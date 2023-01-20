from pydantic import AnyUrl, BaseSettings, HttpUrl, SecretStr


class EdgedbDsn(AnyUrl):
    allowed_schemes = {"edgedb"}
    user_required = True


class Settings(BaseSettings):
    BOT_TOKEN: SecretStr
    EDGEDB_URL: EdgedbDsn
    SENTRY_URL: HttpUrl | None

    I18N_PATH: str
    I18N_DOMAIN: str
    I18N_DEFAULT_LOCALE: str

    WEBHOOK_URL: HttpUrl | None
    PORT: int | None


SETTINGS = Settings()
