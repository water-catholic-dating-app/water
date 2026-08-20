<p align="center">
<h3 align="center">Water</h3>
<p align="center">
Catholic dating app, fork of Duolicious</p>
</p>

<p align="center">
<a href="LICENSE"><img src="https://img.shields.io/badge/license-AGPL--3.0-7700ff" alt="AGPL-3.0 licensed"/></a>
</p>

## How it works

- **Matching on answers, not just photos.** The question bank has many
  questions covering many things. Duolicious has 2,005 questions, but the number of questions in Water will be lower after I finish modifying the questions. You
  don't have to answer them all — Water surfaces matches after your first
  answer, and refines them as you answer more.
- **Psychometric traits.** Alongside familiar frameworks like the MBTI,
  Water shows how you compare to others on traits such as attachment style
  and thriftiness.
- **No swiping.** There's no liking or swiping. People introduce themselves by
  sending a message, and the app discourages low-effort openers like "hey" and
  "sup".
- **Open source and libre.** The app, API, chat, and infrastructure are all in this repo.
  Anyone can read the code, run their own instance, file an issue, or send a fix.
- **Funding.** Water and all of its features will be free to use and have no ads. Eventually I will probably establish a nonprofit organization that can accept tax-deductible donations to fund server costs.

## What's in this repo

This monorepo contains both halves of Water:

| Directory | What it is |
| --- | --- |
| [`backend/`](backend/) | The API, chat, cron and supporting services (Python + Postgres). See its [README](backend/README.md) and [DEVELOPER.md](backend/DEVELOPER.md). |
| [`frontend/`](frontend/) | The cross-platform app (Expo / React Native, with a web build). See its [README](frontend/README.md) and [DEVELOPER.md](frontend/DEVELOPER.md). |

## Run the whole app in one command

Requirements: Docker (with Compose v2.20+).

```bash
git clone https://codeberg.org/water-catholic-dating-app/water.git
cd water
docker compose up
```

That single command builds and starts the entire backend stack **and** the
frontend web app. Once it's up:

- **Frontend (web):** http://localhost:8081
- **API health:** http://localhost:5000/health
- **MailHog (test email UI):** http://localhost:8025
- **Mock S3:** http://localhost:9090
- **Status page:** http://localhost:8080

The frontend's default API URLs already point at the backend's published
localhost ports, so the web app talks to your local backend with no extra
configuration.

The local `docker compose up` stack runs without any secrets — it mocks the
OpenAI-backed features (account verification and club SEO descriptions), so you
don't need a key for development.

A real deployment **requires** `OPENAI_API_KEY`: the cron container won't start
without it, so a misconfigured deploy fails fast instead of silently shipping
broken verification. See [`backend/DEVELOPER.md`](backend/DEVELOPER.md) for the
full list of environment variables.

To seed a test user once the API is healthy:

```bash
(cd backend && ./test/util/create-user.sh alice 30 1 true)
```

### Working on just one half

You can develop each side on its own — see the per-directory READMEs and
`DEVELOPER.md` files linked in the table above. The root `docker compose up` is
still the easiest way to get everything running at once.

## Tests

CI runs the full test suite for both halves on every push and pull request to
`main`:

- **Backend:** mypy, unit tests, and functionality suites 1–6.
- **Frontend:** ESLint, Jest, Playwright, and TypeScript type checks.

Water's CI is defined in [`.woodpecker.yml`](.woodpecker.yml), which runs some (but not all) files in [`.github/workflows/`](.github/workflows/) using a GitHub Actions compatibility layer, in order to avoid the burden of maintaining a translated version of Duolicious's GitHub Actions files.
