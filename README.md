# GPA Team Marks (GPA TM)

Peer assessment platform for fair, transparent grading in group projects.

## Introduction

This platform helps students evaluate each other’s contributions in group projects fairly and easily. It automatically calculates individual marks using proven fairness models, ensuring every student gets credit for their real effort and teamwork.

This is based on mathematical models called **QASS** and **WebAvalia** respectively suggested by Prof. Paul Hubert Vossen, Dr. Suraj Ajit and Professor Rosalina Babo.

I implemented the models along with deriving a new method of inter-converting the models for a better understanding of both evaluations.

## Overview

Teachers create courses, organize students into groups, and configure peer-assessment assignments using either evaluation model. Students submit peer marks within their group; once all submissions are complete, the platform runs the corresponding scoring pipeline and produces individual final marks.

| Role | Responsibilities |
|------|------------------|
| **Super Admin** | System-wide administration |
| **Admin** | School management, bulk import of teachers and students |
| **Teacher** | Courses, groups, assignments, mark review, final mark persistence |
| **Student** | Peer marking (draft/submit), view own final marks |



## Tech Stack

- **Ruby** 3.4.2
- **Rails** 8.0
- **PostgreSQL**
- **Devise** (role-based authentication: super admin, admin, teacher, student)
- **Tailwind CSS**, Hotwire (Turbo + Stimulus)
- **RSpec**, Capybara, Factory Bot (testing)


## Screenshots
### Super Admin
Dashboard
<img width="1633" height="765" alt="image" src="https://github.com/user-attachments/assets/b1d6bbf6-2fab-471c-ad5b-0f6e4b56ac5f" />

### Admin
Login Page
<img width="1642" height="828" alt="image" src="https://github.com/user-attachments/assets/5fcdc2cb-16f6-46bd-b9fe-774e9b459272" />
Dashboard
<img width="1642" height="828" alt="image" src="https://github.com/user-attachments/assets/311e7737-9bfe-4965-8b20-f31180254ea5" />
Import Teacher / Student
<img width="1642" height="828" alt="image" src="https://github.com/user-attachments/assets/d8c41637-07f0-4932-9958-56107550cea6" />

### Teachers
Dashboard
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/9e10d5a2-a3fc-4b4a-8b54-254b0b2f29b6" />
Create a new Course
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/b8d46eef-0d35-415b-89ab-fb009097d648" />
View my courses
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/680e253a-2094-4b6c-8792-c41d6429a2dc" />
Enrolled Students
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/a1f68ba5-5f42-4538-9603-4dd049923a0f" />
Manage Groups
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/600c38d4-69b8-4b63-bac0-fb3c52d5c106" />
Edit a group
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/801c14e8-e731-46e1-b639-e03397207752" />
Create a new Assignment
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/1fb1f581-5b69-4d62-9fa1-cb79b3267f9d" />
Choose the model
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/d56f06b0-ba4e-4db6-a4a8-30aad5aa2171" />
Set parameters
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/9a921bfa-31b5-4fe8-8245-d8360eae302b" />
View All Assignments
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/e9a3e1ed-c7c1-414f-9044-19657b995274" />
View Assignment Group Submissions
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/6d67f033-1946-4e01-b804-9df233a1129a" />
View Group Peer Matrix (WebAvalia)
<img width="1642" height="803" alt="image" src="https://github.com/user-attachments/assets/dea60532-95c9-4e55-b052-5fe9856bd6c2" />
View Final Evaluation (WebAvalia)
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/aac326da-42ca-406e-92b2-c71050ab05f4" />
Compare with other model (QASS)
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/9f291f79-d774-402c-8845-fcb342027081" />
Intermediate steps and formulas:
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/d8418941-6504-4a2a-ac9a-a7d76ed0be79" />
Editing group score (This updates final score in real time)
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/87cd0109-a808-486b-b731-575a468c2814" />
Final Marks
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/eeccceb9-5e30-494c-b369-3abaf6e3f893" />
Student Dashboard
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/26f2c072-bb33-490d-8fb4-cb8441017256" />
Students Marks
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/8749f3b9-fa43-42ef-a5b8-a025bcc174cf" />
Students View Final Score
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/58d52de0-62e5-4fce-b58c-3beeb9cb178f" />
<img width="1666" height="830" alt="image" src="https://github.com/user-attachments/assets/34f75c46-929d-46be-9058-6b13f5b180fa" />



## Assignment Types

Assignments are created via a multi-step wizard and must be one of:

| Type | Description |
|------|-------------|
| **QASS** (Quasi-Arithmetic Scoring System) | Uses quasi-arithmetic means to standardize peer ratings and redistribute a group score across students. Supports rating models **B**, **C**, and **D**. |
| **WebAvalia** | Uses weighted averaging: students allocate points that sum to 100 per giver; marks are normalized, weighted (self vs peer), and scaled to a group project score. |

### QASS configuration

- `lower_bound` / `upper_bound` — rating scale (default 1–7)
- `rating_model` — B, C, or D (affects border, rescale, calibration, and contribution formulas)
- `border_size`, `polarity_factor`, `group_spread` — tuning parameters for the pipeline
- `group_score` — target group performance (0.00–1.00) used in final mark calculation

### WebAvalia configuration

- `rating_scale` — step size for integer marks (e.g. multiples of 5)
- `self_rating_weight` — percentage weight for self-ratings vs peer ratings

## Core Services

### `QassStandardizationService`

Implements the full QASS pipeline for a given assignment and group. Only runs when every group member has submitted and the peer matrix is complete (`n²` marks from submitted givers).

**Pipeline stages** (exposed as methods and rendered step-by-step in the teacher UI):

1. **Standardization** — normalize raw scores to [0, 1] using assignment bounds
2. **Bordered peer ratings** — apply border size; behavior depends on rating model (B/C/D)
3. **Rescaled peer ratings** — model-specific rescaling (e.g. `v / (1 - v)` for model B)
4. **Calibrated peer ratings** — self-calibration for model B (skipped for C/D)
5. **Weighted peer ratings** — apply weight `j` (default 0.20)
6. **Student ratings** — product of weighted ratings per receiver
7. **Mean student rating** — aggregate across students
8. **Student contributions** — polarity-adjusted relative contributions
9. **Student contributions (cᵢ)** — transformed contributions for final scoring
10. **Mean student contribution / c̄** — group-level contribution index
11. **Student scores** — `t^(z^v)` using group score `t` and spread `z`

Final marks for QASS assignments are stored as `score × 100` (e.g. 0.805 → 80.5) via `AssignmentsController#save_final_marks`.

### `WebavaliaService`

Implements the WebAvalia weighted-averaging model:

1. **Weighted peer marks** — split each giver’s allocation between self-rating weight and equal peer weight
2. **Row sums** — sum of weighted marks received per student
3. **DivideMax** — each row sum divided by the maximum row sum
4. **Grade** — `DivideMax × group_score` (default group score 18 on a 0–20 scale)
5. **Final grade** — rounded integer grades

For **QASS → WebAvalia conversion**, `WebavaliaService` is initialized with `converted: true`, which:

- Normalizes each giver’s QASS-scale marks to percentages, rounds to multiples of 5, and adjusts so each row sums to 100
- Uses a fixed 15% self-rating weight for the converted view

### Model inter-conversion

A distinctive feature of this implementation is **bidirectional comparison** between models on the same peer data:

| Direction | Mechanism |
|-----------|-----------|
| **WebAvalia → QASS** | `QassStandardizationService` with `conversion: 'webavalia-to-qass'`: maps scores from 1–100 to 1–7 (`1 + ((score - 1) / 99) × 6`), scales group score from 0–20 to QASS `t`, and runs the QASS pipeline with model B defaults |
| **QASS → WebAvalia** | `WebavaliaService` with `converted: true`: normalizes QASS marks into WebAvalia’s 100-point allocation format, then runs the WebAvalia pipeline |

Teachers toggle conversion from the assignment show page (`conversion=webavalia-to-qass` or `conversion=qass-to-webavalia`) without changing stored peer marks.

## Application Flow (Controllers)

### `AssignmentsController`

Central hub for teachers/admins:

- CRUD for assignments under courses
- **Wizard**: `new_wizard` → `select_course` → `select_type` (QASS vs WebAvalia)
- **`view_marks`** — peer matrix + live calculation tables (QASS steps or WebAvalia table)
- **`save_group_marks`** — persist per-group project score (`AssignmentGroupScore`)
- **`save_final_marks`** — run `WebavaliaService` or `QassStandardizationService` and persist `FinalMark` records
- **`generate_sample_peer_marks`** — development/demo data generator

### `StudentPeerMarksController`

Student peer-marking workflow:

- **`edit`** — marking grid for all group members (QASS: float steps 0.01; WebAvalia: integer scale)
- **`update`** — save draft or finalize (`finalize` param locks submission)
- **`submit`** — save and lock marks
- **`summary`** — review submitted marks

Submissions are validated: WebAvalia requires each giver’s marks to sum to **100**; QASS uses bounded scale marks without that constraint.

### Supporting controllers

- **`CoursesController`** / **`GroupsController`** — course setup, random group generation, student membership
- **`StudentsController`** — dashboard, assignments list, view own `FinalMark`
- **`SchoolsController`**, **`AdminsController`**, **`SuperAdminsController`** — institutional hierarchy and imports
- **`Users::SessionsController`** / **`Users::RegistrationsController`** — separate sign-in/up paths per role

## Data Model (high level)

```
School → Course → Assignment → PeerMark (giver × receiver matrix)
                → Group → Students
                → PeerMarkSubmission (per giver, submitted flag)
                → AssignmentGroupScore (per group)
                → FinalMark (per student, after teacher saves)
```

Only peer marks from **submitted** givers are included in calculations.

## Setup and run locally

Follow these steps on your machine to run the app in development.

### 1. Prerequisites

Install the following before cloning:

| Tool | Version | Notes |
|------|---------|--------|
| **Ruby** | 3.4.2 | Use [rbenv](https://github.com/rbenv/rbenv), [asdf](https://asdf-vm.com/), or [mise](https://mise.jdx.dev/); `.ruby-version` is in the repo |
| **Bundler** | Latest | `gem install bundler` |
| **PostgreSQL** | 9.3+ | Must be running locally (default port `5432`) |
| **Git** | Any recent | To clone the repository |

**macOS (Homebrew example):**

```bash
brew install ruby@3.4 postgresql@16
brew services start postgresql@16
```

**Ubuntu/Debian (example):**

```bash
sudo apt update
sudo apt install ruby-full build-essential libpq-dev postgresql postgresql-contrib
sudo systemctl start postgresql
```

### 2. Clone the repository

```bash
git clone https://github.com/dev-abdul-majeed/gpa_tm
cd gpa_tm
```

### 3. Install Ruby dependencies

```bash
# If using rbenv/asdf, install the correct Ruby first:
# rbenv install   # reads .ruby-version

bundle install
```

### 4. Configure the database

Development and test databases are defined in `config/database.yml`:

- **Development:** `gpa_tm_development`
- **Test:** `gpa_tm_test`
- **Host:** `localhost` (override with `DATABASE_HOST`)
- **Port:** `5432` (override with `DATABASE_PORT`)

By default, Rails connects as your **OS username** with no password (typical on macOS/Linux). If your PostgreSQL setup uses a different user or password, uncomment and set `username` / `password` in `config/database.yml`, or export a connection URL:

```bash
export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/gpa_tm_development"
```

Create and migrate the databases:

```bash
bin/rails db:create
bin/rails db:migrate
```

Or in one step (create, migrate, and load schema if needed):

```bash
bin/rails db:prepare
```

### 5. (Optional) Seed demo data

`db/seeds.rb` loads schools, a super admin, admin, teachers, and students for local testing:

```bash
bin/rails db:seed
```

**Demo accounts** (password for all: `123456`):

| Role | Email | Sign-in URL |
|------|-------|-------------|
| Super Admin | `sa@example.com` | `/super_admins/sign_in` |
| Admin | `admin@example.com` | `/admins/sign_in` |
| Teacher | `jd@example.com` (and others in seeds) | `/teachers/sign_in` |
| Student | `a@example.com` … `z@example.com` | `/students/sign_in` |

### 6. Start the development server

The app uses [Foreman](https://github.com/ddollar/foreman) via `bin/dev` to run the Rails server and Tailwind CSS watcher together:

```bash
bin/dev
```

This starts:

- **Web** — Rails on [http://localhost:3000](http://localhost:3000) (override with `PORT=3001 bin/dev`)
- **CSS** — Tailwind rebuild on file changes

**Alternative:** run only the web server (compile CSS once separately if needed):

```bash
bin/rails server
# In another terminal:
bin/rails tailwindcss:watch
```

**One-command setup** (install gems, prepare DB, then start `bin/dev`):

```bash
bin/setup
```

Skip auto-starting the server:

```bash
bin/setup --skip-server
```

### 7. Open the app

1. Visit [http://localhost:3000](http://localhost:3000)
2. Sign in with a seeded account (see table above) or register a new teacher/student via the sign-up links on the home page
3. As a **teacher**: create a course, add groups and students, then create a QASS or WebAvalia assignment from the assignment wizard
4. As a **student**: open an assignment and submit peer marks from the student dashboard

### 8. Run tests

```bash
bundle exec rspec
```

Ensure the test database exists (`bin/rails db:test:prepare` if migrations fail in CI/local test runs).

### Troubleshooting

| Issue | What to try |
|-------|-------------|
| `connection refused` to PostgreSQL | Start PostgreSQL (`brew services start postgresql` or `sudo systemctl start postgresql`) |
| `role "your_user" does not exist` | Create a PostgreSQL user matching your OS user, or set `DATABASE_URL` / `username` in `database.yml` |
| `Could not find gem` | Run `bundle install` from the project root |
| Wrong Ruby version | `ruby -v` should show 3.4.2; use rbenv/asdf to match `.ruby-version` |
| CSS not updating | Ensure `bin/dev` is running (includes `tailwindcss:watch`) or run `bin/rails tailwindcss:build` |
| Foreman not found | `bin/dev` installs foreman automatically; or run `gem install foreman` |

## Key routes

| Path | Purpose |
|------|---------|
| `/` | Home |
| `/super_admins/sign_in` | Super Admin Login | 
| `/teacher/home`, `/student/home` | Role dashboards |
| `/courses/:id/assignments` | Manage assignments |
| `/assignments/:assignment_id/groups/:id/view_marks` | Teacher mark review & calculations |
| `/student/courses/:course_id/assignments/:assignment_id/marking` | Student peer marking |

## Project structure (implementation focus)

```
app/
  controllers/
    assignments_controller.rb      # Mark review, final mark persistence
    student_peer_marks_controller.rb
  services/
    qass_standardization_service.rb  # QASS pipeline + WebAvalia→QASS conversion
    webavalia_service.rb               # WebAvalia pipeline + QASS→WebAvalia conversion
  views/assignments/
    view_marks.html.erb              # QASS step-by-step tables
    _webavalia_step1_table.html.erb  # WebAvalia calculation table
```

## Acknowledgements

- **QASS** — Prof. Paul Hubert Vossen (Quasi-Arithmetic Scoring System / System Q)
- **WebAvalia** — Dr. Suraj Ajit and Prof. Rosalina Babo

Inter-conversion logic and Rails implementation are original contributions in this codebase.

## Completed as my Masters dissertation for MSC Computing in University of Northampton, United Kingdom
