# some-bot
## Copyleft
This template and this README.md are (un)licensed under the terms of [Unlicense](https://unlicense.org/).
## Before start
1. Change project name in `pyproject.toml`, `Makefile` and `README.md` files.
2. Change default i18n language in `Makefile` file.
## Requirements for dev environment
1. `Git`
2. `Makefile`
3. `Python 3.11`
4. `Poetry`
5. `EdgeDB`
### Optional
1. `Docker`
2. `docker-compose`
## Project structure
- `app` - main application directory.
- `app/settings.py` - settings file; all values are taken from the environment variables.
- `app/filters` - filters for routers and handlers.
- `app/routers` - aiogram routers.
- `app/routers/main.py` - main router, includes all other routers.
- `app/models` - database models.
- `app/middlewares` - aiogram middlewares.
- `app/setup` - functions that will be called on startup.
- `app/setup/setup.py` - main on startup function, calls all other functions.
- `app/__main__.py` - main file, starts bot.
- `scripts/run.sh` - Docker entrypoint; makes migrations and starts bot.
## Settings
### Linters
This template uses rather strict linter settings. Please configure the linters as you wish.
- mypy - `mypy.ini`
- ruff - `pyproject.toml#tool.ruff` and `pyproject.toml#tool.ruff.mccabe`
- black - `pyproject.toml#tool.black`
### Runtime
The bot is configured using environment variables.
Possible environment variables are described in the `example.env` file.
### I18n
By default, the bot uses user language information from Telegram.
If you need to implement more complex logic, configure i18n middleware in `app/setup/i18n.py`.

More on https://docs.aiogram.dev/en/dev-3.x/utils/i18n.html
### Storage
By default, the bot uses `MemoryStorage` and `SimpleEventIsolation`.
Please configure storage in `app/setup/storage.py`.

More on https://docs.aiogram.dev/en/dev-3.x/dispatcher/finite_state_machine/storages.html
## Install dev environment
Run `make install`.
This command will
1. Install all dependencies via `poetry`
2. Setup `pre-commit`
3. Init `i18n` stuff.
4. Init `EdgeDB` project.
5. **Init** Git repository and **create** first commit.

You can find other usefully commands via `make help` command.
## Cases
### Update translations
1. Run `make text-update`.
2. Translate new strings in `app/{YOUR_LOCALES_DIR}/{LANG}/LC_MESSAGES/messages.po`.
3. Run `make text-compile`.
### Add new language
1. Run `text-create-language language=YOUR_LANGUAGE`.
2. Translate strings in `app/{YOUR_LOCALES_DIR}/{LANG}/LC_MESSAGES/messages.po`.
3. Run `make text-compile`.
