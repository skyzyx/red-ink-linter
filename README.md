# “Red Ink” Linter

> [!IMPORTANT]
> Not ready for use yet. The code nowhere near matches the README.

This is a stripped-down, hard-fork of [Super Linter](https://github.com/super-linter/super-linter). Its goals are similar, but slightly different from Super Linter.

* Prevent broken code from being uploaded to the default branch (_Usually_ `master` or `main`).
* Help establish coding best practices across multiple languages.
* Build guidelines for code layout and format.
* Automate the process to help streamline code reviews.
* Automatically comment on PRs suggesting code corrections, which can be accepted into the PR, further reducing friction in keeping code clean.
* _Focus on the tooling that I actually use._

## How it Works

**Red Ink** finds issues and reports them on the PR that triggered them. A status check will show up as failed on the pull request.

The design of **Red Ink** is to enable linting to occur in GitHub Actions as a part of continuous integration occurring on pull requests as the commits get pushed. It works best when commits are being pushed early and often to a branch with an open or draft pull request.

## Supported Linters

| Language             | Linter                                                                   |
|----------------------|--------------------------------------------------------------------------|
| AWS CloudFormation   | TBD                                                                      |
| CSS                  |                                                                          |
| Copy/paste detection |                                                                          |
| Dockerfile           |                                                                          |
| EditorConfig         |                                                                          |
| ENV                  |                                                                          |
| GitHub Actions       |                                                                          |
| Golang               |                                                                          |
| HTML                 |                                                                          |
| JavaScript           |                                                                          |
| JSON                 | [eslint-plugin-json](https://www.npmjs.com/package/eslint-plugin-json)   |
| JSONC                | [eslint-plugin-jsonc](https://www.npmjs.com/package/eslint-plugin-jsonc) |
| Markdown             |                                                                          |
| Natural language     |                                                                          |
| Python3              |                                                                          |
| Secrets              |                                                                          |
| Shell                |                                                                          |
| Terraform            |                                                                          |
| YAML                 | [YamlLint](https://github.com/adrienverge/yamllint)                      |

## Configuration

### Step one

Turn the linter _on_.

| ENV VAR                     | Default Value | Notes                                                                                                                                                                  |
|-----------------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ENABLE_ACTIONLINT`         | `false`       | Enable processing with [Actionlint](https://github.com/rhysd/actionlint).                                                                                              |
| `ENABLE_CHECKOV`            | `false`       | Enable processing with [Checkov](https://checkov.io).                                                                                                                  |
| `ENABLE_DOTENV_LINTER`      | `false`       | Enable processing with [dotenv-linter](https://github.com/dotenv-linter/dotenv-linter).                                                                                |
| `ENABLE_EDITORCONFIG`       | `false`       | Enable processing with [EditorConfig](https://editorconfig.org) and [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker).              |
| `ENABLE_DETECT_SECRETS`     | `false`       | Enable processing with [detect-secrets](https://github.com/Yelp/detect-secrets).                                                                                       |
| `ENABLE_GITLEAKS`           | `false`       | Enable processing with [Gitleaks](https://gitleaks.io).                                                                                                                |
| `ENABLE_GO_MOD_TIDY`        | `false`       | Run `go mod tidy -go={target_version}`.                                                                                                                                |
| `ENABLE_GO_MOD_UPDATE`      | `false`       | Run `go get -u ./...`.                                                                                                                                                 |
| `ENABLE_GOFUMPT`            | `false`       | Enable processing with [gofumpt](https://github.com/mvdan/gofumpt).                                                                                                    |
| `ENABLE_GOLANGCI_LINT`      | `false`       | Enable processing with [golangci-lint](https://golangci-lint.run).                                                                                                     |
| `ENABLE_HADOLINT`           | `false`       | Enable processing with [Hadolint](https://hadolint.github.io/hadolint/).                                                                                               |
| `ENABLE_MARKDOWNLINT`       | `false`       | Enable processing with [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) (which wraps [markdownlint](https://github.com/DavidAnson/markdownlint)). |
| `ENABLE_PRETTY_JSON`        | `false`       | Rewrite JSON files in pretty-printed format.                                                                                                                           |
| `ENABLE_PYUPGRADE`          | `false`       | Enable processing with [pyupgrade](https://github.com/asottile/pyupgrade).                                                                                             |
| `ENABLE_REORDER_PY_IMPORTS` | `false`       | Enable processing with [reorder-python-imports](https://github.com/asottile/reorder-python-imports).                                                                   |
| `ENABLE_SHELLCHECK`         | `false`       | Enable processing with [Shellcheck](https://www.shellcheck.net).                                                                                                       |
| `ENABLE_SHFMT`              | `false`       | Enable processing with [shfmt](https://github.com/mvdan/sh).                                                                                                           |
| `ENABLE_TERRAFORM_FMT`      | `false`       | Enable formatting Terraform files.                                                                                                                                     |
| `ENABLE_TERRAFORM_LOCK_ALL` | `false`       | Enable generating a [Terraform lock file](https://developer.hashicorp.com/terraform/cli/commands/providers/lock) which contains all appropriate platforms.             |
| `ENABLE_TERRAFORM_VALIDATE` | `false`       | Enable validating Terraform projects.                                                                                                                                  |
| `ENABLE_TERRASCAN`          | `false`       | Enable processing with [Terrascan](https://runterrascan.io).                                                                                                           |
| `ENABLE_TFLINT`             | `false`       | Enable processing with [tflint](https://github.com/terraform-linters/tflint).                                                                                          |
| `ENABLE_TRIVY`              | `false`       | Enable processing with [Trivy](https://aquasecurity.github.io/trivy/).                                                                                                 |
| `ENABLE_YAMLFMT`            | `false`       | Enable processing with [yamlfmt](https://github.com/google/yamlfmt).                                                                                                   |
| `ENABLE_YAPF`               | `false`       | Enable processing with [yapf](https://github.com/google/yapf).                                                                                                         |

<!--
| `ENABLE_CFN_LINT`           | `true`                    | Enable processing with [cfn-lint](https://github.com/aws-cloudformation/cfn-python-lint/).                                                                             |
| `ENABLE_CFN_NAG`            | `true`                    | Enable processing with [cfn_nag](https://github.com/stelligent/cfn_nag).                                                                                               |
| `ENABLE_ESLINT`             | `true`                    | Enable processing with [ESLint](https://eslint.org).                                                                                                                   |
| `ENABLE_FLAKE8`             | `true`                    | Enable processing with [flake8](https://flake8.pycqa.org).                                                                                                             |
| `ENABLE_HTMLHINT`           | `true`                    | Enable processing with [HTMLHint](https://htmlhint.com).                                                                                                               |
| `ENABLE_ISORT`              | `true`                    | Enable processing with [isort](https://pypi.org/project/isort/).                                                                                                       |
| `ENABLE_JSCPD`              | `false`                   | Enable processing with [jscpd](https://github.com/kucherenko/jscpd).                                                                                                   |
| `ENABLE_MYPY`               | `true`                    | Enable processing with [Mypy](https://mypy-lang.org).                                                                                                                  |
| `ENABLE_PRETTIER`           | `true`                    | Enable processing with [Prettier](https://prettier.io).                                                                                                                |
| `ENABLE_PYLINT`             | `true`                    | Enable processing with [Pylint](https://pylint.readthedocs.io).                                                                                                        |
| `ENABLE_STYLELINT`          | `true`                    | Enable processing with [Stylelint](https://stylelint.io).                                                                                                              |
| `ENABLE_XML`                | `true`                    | Enable processing                                                                                                                                                      |
| `ENABLE_YAMLLINT`           | `true`                    | Enable processing                                                                                                                                                      |
-->

### Step two

Once the linter is _on_, you can configure it.

| ENV VAR                       | Default Value                                                           | Notes                                                                                                               |
|-------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| `ACTIONLINT_ARGS`             | `[]`                                                                    | Additional arguments passed to the `actionlint` command.                                                            |
| `ACTIONLINT_CONFIG`           | `actionlint.yml`                                                        | Filename for [Actionlint configuration](https://github.com/rhysd/actionlint/blob/main/docs/config.md).              |
| `CHECKOV_ARGS`                | `[]`                                                                    | Additional arguments passed to the `checkov` command.                                                               |
| `CHECKOV_CONFIG`              | `.checkov.yml`                                                          | Filename for [checkov configuration](https://www.checkov.io).                                                       |
| `EDITORCONFIG_CHECKER_CONFIG` | `.ecrc`                                                                 | Filename for [editorconfig-checker configuration](https://github.com/editorconfig-checker/editorconfig-checker).    |
| `EDITORCONFIG_CONFIG`         | `.editorconfig`                                                         | Filename for [editorconfig configuration](https://editorconfig.org).                                                |
| `FIXME_TODO_KEYWORDS`         | `[FIXME, TODO]`                                                         | Words to look for in the source code.                                                                               |
| `GITHUB_API_URL`              | `https://api.github.com`                                                | Specify a custom GitHub API URL in case GitHub Enterprise is used (e.g., `https://github.myenterprise.com/api/v3`). |
| `GITHUB_DOMAIN`               | `github.com`                                                            | Specify a custom GitHub domain in case GitHub Enterprise is used (e.g., `github.myenterprise.com`).                 |
| `GITLEAKS_CONFIG`             | `.gitleaks.toml`                                                        | Filename for [GitLeaks configuration](https://github.com/zricethezav/gitleaks#configuration).                       |
| `GO_MOD_TIDY_ARGS`            | `[-go=1.19]`                                                            | Additional arguments passed to the `go mod tidy` command.                                                           |
| `HADOLINT_ARGS`               | `[]`                                                                    | Additional arguments passed to the `hadolint` command.                                                              |
| `HADOLINT_CONFIG`             | `.hadolint.yaml`                                                        | Filename for [hadolint configuration](https://github.com/hadolint/hadolint).                                        |
| `LARGE_FILES_MAX_KB`          | `768`                                                                   | The maximum number of kilobytes a file can be without triggering a failure.                                         |
| `MARKDOWNLINT_ARGS`           | `[]`                                                                    | Additional arguments passed to the `markdownlint-cli` command.                                                      |
| `MARKDOWNLINT_CONFIG`         | `.markdownlint.json`                                                    | Filename for [Markdownlint configuration](https://github.com/DavidAnson/markdownlint#optionsconfig).                |
| `PYUPGRADE_PYTHON_TARGET`     | `py38-plus`                                                             | The version of Python to target.                                                                                    |
| `REORDER_PY_IMPORTS_ARGS`     | `[]`                                                                    | Additional arguments passed to the `reorder-python-imports` command.                                                |
| `SHELLCHECK_ARGS`             | `[]`                                                                    | Additional arguments passed to the `shellcheck` command.                                                            |
| `SHELLCHECK_SEVERITY`         | `style`                                                                 | Specify the minimum severity of errors to consider in Shellcheck.                                                   |
| `SHFMT_ARGS`                  | `[]`                                                                    | Additional arguments passed to the `shfmt` command.                                                                 |
| `TERRAFORM_LOCK_PLATFORMS`    | `[darwin_amd64, darwin_arm64, linux_amd64, linux_arm64, windows_amd64]` | Platforms to build the Terraform lockfile for.                                                                      |
| `TERRASCAN_ARGS`              | `[]`                                                                    | Additional arguments passed to the `terrascan` command.                                                             |
| `TERRASCAN_CONFIG`            | `terrascan.toml`                                                        | Filename for [terrascan configuration](https://github.com/accurics/terrascan).                                      |
| `TFLINT_ARGS`                 | `[]`                                                                    | Additional arguments passed to the `tflint` command.                                                                |
| `TFLINT_CONFIG`               | `.tflint.hcl`                                                           | Filename for [tflint configuration](https://github.com/terraform-linters/tflint)                                    |
| `TRIVY_ARGS`                  | `[]`                                                                    | Additional arguments passed to the `trivy` command.                                                                 |
| `TRIVY_CONFIG`                | `trivy.yaml`                                                            | Filename for [trivy configuration](https://aquasecurity.github.io/trivy/latest/docs/configuration/).                |
| `YAMLFMT_CONFIG`              | `.yamlfmt.yml`                                                          | Filename for [Yamlfmt configuration](https://github.com/google/yamlfmt/blob/main/docs/config-file.md).              |
| `YAPF_ARGS`                   | `[]`                                                                    | Additional arguments passed to the `yapf` command.                                                                  |
| `YAPF_CONFIG`                 | `.style.yapf`                                                           | Filename for [yapf configuration](https://github.com/google/yapf#knobs).                                            |

<!--
| `ESLINT_CONFIG`               | `.eslintrc.yml`           | Filename for [ESLint configuration](https://eslint.org/docs/user-guide/configuring#configuration-file-formats).                                                        |
| `FLAKE8_CONFIG`               | `.flake8`                 | Filename for [flake8 configuration](https://flake8.pycqa.org/en/latest/user/configuration.html).                                                                       |
| `ISORT_CONFIG`                | `.isort.cfg`              | Filename for [isort configuration](https://pycqa.github.io/isort/docs/configuration/config_files.html).                                                                |
| `JSCPD_CONFIG`                | `.jscpd.json`             | Filename for JSCPD configuration.                                                                                                                                      |
| `MYPY_CONFIG`                 | `.mypy.ini`               | Filename for [mypy configuration](https://mypy.readthedocs.io/en/stable/config_file.html).                                                                             |
| `PYLINT_CONFIG`               | `.python-lint`            | Filename for [pylint configuration](https://pylint.pycqa.org/en/latest/user_guide/run.html?highlight=rcfile#command-line-options).                                     |
| `STYLELINT_CONFIG`            | `.stylelintrc.json`       | Filename for [Stylelint configuration](https://github.com/stylelint/stylelint).                                                                                        |
| `YAMLLINT_CONFIG`             | `.yamllint.yml`           | Filename for [Yamllint configuration](https://yamllint.readthedocs.io/en/stable/configuration.html).                                                                   |

https://github.com/adrienverge/yamllint
https://github.com/adamchainz/flake8-logging
https://github.com/adamchainz/flake8-comprehensions
https://github.com/adamchainz/flake8-no-pep420
https://check-jsonschema.readthedocs.io/en/latest/usage.html

https://github.com/gruntwork-io/pre-commit
packer-validate: Automatically run packer validate on all Packer code (*.pkr.* files).
terragrunt-hclfmt: Automatically run terragrunt hclfmt on all Terragrunt configurations.
-->

### Step three

Other general checks and settings.

| ENV VAR                            | Default Value | Notes                                                                                                                       |
|------------------------------------|---------------|-----------------------------------------------------------------------------------------------------------------------------|
| `ENABLE_CHECK_BOM`                 | `false`       | Check that files do not contain a UTF-8 BOM.                                                                                |
| `ENABLE_CHECK_CASE_CONFLICT`       | `false`       | Check for files with names that would conflict on a case-insensitive filesystem like macOS HFS+ or Windows FAT.             |
| `ENABLE_CHECK_END_OF_FILE`         | `false`       | Check that files end in a newline and only a newline.                                                                       |
| `ENABLE_CHECK_EXEC_HAS_SHEBANG`    | `false`       | Check non-binary executables for a proper shebang. May run alongside `ENABLE_CHECK_SHEBANG_HAS_EXEC`.                       |
| `ENABLE_CHECK_FIXME_TODO`          | `false`       | Check that there are no `FIXME` and `TODO` markers in the newly-written code.                                               |
| `ENABLE_CHECK_LARGE_FILES`         | `false`       | Check for files that are large, and flag them as needing to move to [Git LFS](https://git-lfs.com).                         |
| `ENABLE_CHECK_LINE_ENDINGS`        | `false`       | Check that line endings bytes match what is expected.                                                                       |
| `ENABLE_CHECK_MERGE_CONFLICT`      | `false`       | Check for files which contain merge conflict markers and `core.whitespace` errors.                                          |
| `ENABLE_CHECK_PRIVATE_KEY`         | `false`       | Checks for the existence of private keys. Will ignore private keys containing the word `EXAMPLE`.                           |
| `ENABLE_CHECK_PY_ENCODING_PRAGMA`  | `false`       | Check that Python files do not contain `# -*- coding: utf-8 -*-`, as Python 2 is dead and this is not required in Python 3. |
| `ENABLE_CHECK_PY_REQUIREMENTS_TXT` | `false`       | Sorts entries in `requirements.txt` and `constraints.txt` and removes incorrect entry for `pkg-resources==0.0.0`.           |
| `ENABLE_CHECK_SHEBANG_HAS_EXEC`    | `false`       | Check that scripts with shebangs are executable. May run alongside `ENABLE_CHECK_EXEC_HAS_SHEBANG`.                         |
| `ENABLE_CHECK_SHELL_SCRIPT_EXT`    | `false`       | Check that shell script filenames end in `.sh`.                                                                             |
| `ENABLE_CHECK_TRAILING_WHITESPACE` | `false`       | Check that lines do not contain trailing whitespace.                                                                        |
| `ENABLE_CHECK_VALID_JSON`          | `false`       | Check that JSON files are syntactically-valid.                                                                              |
| `ENABLE_CHECK_VALID_PYTHON`        | `false`       | Check that Python files are syntactically-valid.                                                                            |
| `ENABLE_CHECK_VALID_TOML`          | `false`       | Check that TOML files are syntactically-valid.                                                                              |
| `ENABLE_CHECK_VALID_XML`           | `false`       | Check that XML files are syntactically-valid.                                                                               |
| `ENABLE_CHECK_VALID_YAML`          | `false`       | Check that YAML files are syntactically-valid.                                                                              |
| `VALIDATE_FILES`                   | `changed`     | Whether to process `all` files in the repository, or only the `changed` files.                                              |

## How to use

1. Create a new file in your repository called `.github/workflows/linter.yml`
1. Copy the example workflow from below into that new file, no extra configuration required
1. Commit that file to a new branch
1. Open up a pull request and observe the action working
1. Enjoy your more _stable_, and _cleaner_ codebase

> [!NOTE]
> If you pass the environment variable `GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}` in your workflow, then this will mark the status of each individual linter run in the _Checks_ section of a pull request. Without this, you will only see the overall status of the full run.
>
> There is no need to create the GitHub Token as it is automatically set by GitHub; it only needs to be passed to the action.

### Example connecting GitHub Action Workflow

In your repository, you should have a `.github/workflows/linter.yml` file similar to:

```yml
---
name: Lint Code Base

on:
  push:
    branches-ignore: [master, main]
    # Remove the line above to run when pushing to master or main
  pull_request:
    branches: [master, main]

# Set the Job
jobs:
  build:
    name: Lint Code Base
    runs-on: ubuntu-latest

    # Grant status permission for MULTI_STATUS
    permissions:
      contents: read
      packages: read
      statuses: write

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3
        with:
          # Full git history is needed to get a proper list of changed files.
          fetch-depth: 0

      - name: Lint Code Base
        uses: skyzyx/red-ink-linter@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Limitations

Below are a list of the known limitations:

* Due to being completely packaged at runtime, you will not be able to update dependencies or change versions of the enclosed linters and binaries.

* Additional details from `package.json` are not read.

* Downloading additional codebases as dependencies from private repositories will fail due to lack of permissions.
