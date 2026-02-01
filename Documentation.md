# Reproducible Analytical Pipelines


## Overall Context and Goals
The core idea is to build reproducible analytical pipelines (RAPs) that produce data products (e.g., reports, apps, or analyses) in a way that's automated, versioned, testable, and shareable.

- RAPs emphasize automation over manual work: code that runs consistently, minimizes errors, and scales.

- It is recommended to employ plain-text scripts, functional programming, and build tools instead of Jupyter notebooks as they introduce "state" (non-reproducible execution order).

- **Why Reproducibility?**: Non-reproducible work leads to "it works on my machine" issues, wasted time, and unscientific results.  
The pillars of reproducibility are:

    - Reproducible environments (Nix): Use Nix (via {rix}) for declarative environments.

    - Reproducible history (Git).

    - Reproducible logic (functional programming and unit testing).

    - Orchestration (pipelines, Docker, CI/CD).

## Steps on Windows

### Step 1: Define the project and set up your workspace
Goal: Plan the analysis and prepare your local setup.

- Ensure WSL is enabled: Open PowerShell as admin, run `wsl --install`
- Install Nix in WSL
- Install Git
- Set up Git globally
- Install VS Code/Positron
- Create project folder in WSL

### Step 2: Set up the reproducible Nix environment with {rix}
Goal: Create a `default.nix` file that defines a reproducible environment containing:

- R
- tidyverse (for data manipulation and ggplot2)
- testthat (for unit testing in R)
- languageserver (for better Positron/VS Code integration)
- Python + pandas, seaborn, matplotlib (for polyglot part)
- quarto (CLI) so we can render documents from the shell

#### 2.1 Create the environment generator script
In your project folder, create a file called `gen-env.R`.

#### 2.2 Run the script inside a temporary Nix shell with {rix}
In your WSL terminal (inside the project folder):

```bash
# Start a temporary shell that has R + {rix}
nix-shell -p R rPackages.rix

# Inside the shell → start R
R
```

Then inside R:

```r
source("gen-env.R")
```

Everytime you update `gen-env.R` file, run the following in WSL terminal:  
`nix-shell -p R rPackages.rix --run "R -e 'source(\"gen-env.R\")'"`

#### 2.3 Activate the environment for development
Create a file called `.envrc` in the project root:

```bash
# .envrc
use nix
mkdir $TMP
```

Then allow it (only needed once):

```bash
direnv allow
```

Now every time you open a terminal in this folder, it should automatically load the Nix shell (you'll see a message like "direnv: loading ...").

Open Positron on Windows, install `direnv` extension, open the project folder and confirm the message to restart the environment.

### Step 3: Writing Pure Functions
- Pure functions (same input → same output, no side effects, no globals)
- Replace loops with map/filter/reduce where natural
- Self-contained, testable, composable

### Step 4 – Unit Testing
We prove our functions work as claimed (happy path, edges, errors). We use `testthat` in R and `pytest` in Python.

#### 4.1 Create test files
...

#### 4.2 R unit tests
...

#### 4.3 Run the R tests
In WSL terminal: `R -e "testthat::test_dir('tests/testthat')"`

In Positron console: `testthat::test_dir('tests/testthat')`

### Step 5 – Create a Simple Quarto Report

#### 5.1 Create the Quarto file
...

#### 5.2 Write the report content
...

#### 5.3 Render the report

In terminal (inside project folder):

```bash
quarto render quarto/iris-analysis-report.qmd
```
