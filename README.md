# Docker image for remark-lint

Docker image for markdown code style linter [remark-lint](https://github.com/remarkjs/remark-lint).

## Get

Pull image from [GitLab Container Registry](https://gitlab.nexium.dev/team-n/containers/remark-lint/container_registry)

```bash
docker pull registry.nexium.dev/team-n/containers/remark-lint
```

## Build

Clone this repository and run

```bash
docker build -t registry.nexium.dev/team-n/containers/remark-lint .
```

## Use

Go to your folder with markdown files you want to lint and run

```bash
docker run --rm -i -v $PWD:/lint/input:ro registry.nexium.dev/team-n/containers/remark-lint .
```

You can even set it up as an alias for remark-cli's command `remark`.

```bash
alias remark="docker run --rm -i -v $PWD:/lint/input:ro registry.nexium.dev/team-n/containers/remark-lint"

remark --version
remark: 14.0.2, remark-cli: 10.0.1
```

Default config is `.remarkrc.yaml`

```yaml
plugins:
  preset-lint-consistent:
  preset-lint-markdown-style-guide:
  preset-lint-recommended:
  validate-links:
```

### Example

```bash
docker run --rm -i -v $PWD:/lint/input:ro registry.nexium.dev/team-n/containers/remark-lint .

README.md
  3:100  warning  Line must be at most 80 characters  maximum-line-length         remark-lint
    8:1  warning  Remove 1 line before node           no-consecutive-blank-lines  remark-lint

⚠ 2 warnings
```

### Rule Customisation

In case you want to customize rules like `maximum-line-length` you can find
examples of configuration in JSON and YAML in the `examples` folder. All you
need to do is copy it to your project root and customize.

See list of all rules in [remark-lint/packages](https://github.com/remarkjs/remark-lint/tree/master/packages).

### Continuous Integration

An option `-f` or `--frail` can be useful for exiting with code `1` in case of
any warning in your CI.

```bash
docker run --rm -i -v $PWD:/lint/input:ro registry.nexium.dev/team-n/containers/remark-lint --frail .
```

#### GitLab CI

Your minimal configuration can look like

```yaml
remark-lint:
  image: "${CI_REGISTRY}/${PROJECT_GROUP_NAME}/containers/remark-lint:edge"
  before_script:
    - remark --version
  script:
    - remark --frail .
  rules:
    - if: '$CI_COMMIT_BRANCH != $CI_DEFAULT_BRANCH'
      changes:
        - '**/*.md'
      exists:
        - '**/*.md'
    - if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH'
      exists:
        - '**/*.md'
```

You can extend this example with your build instructions and tests or add it
as a job to one of your stages.
