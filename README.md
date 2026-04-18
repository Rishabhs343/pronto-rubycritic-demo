# pronto-rubycritic-demo

A comprehensive sample Ruby project that demonstrates
[pronto-rubycritic](https://github.com/Rishabhs343/custom-pronto-gem)
in every supported configuration and against every smell category.

Open **[PR #1](https://github.com/Rishabhs343/pronto-rubycritic-demo/pull/1)**
to see the runner comment on every added smelly line.

---

## Repository layout

```
.
├── .github/workflows/pronto.yml        # runs pronto-rubycritic on every PR
├── .gitlab-ci.yml                       # runs pronto-rubycritic on every MR
├── .rubycritic-pronto.yml               # default filter (generous)
├── Gemfile                              # pulls the gem from GitHub
├── README.md
├── app/                                 # ONE file per smell category
│   ├── clean.rb                         # clean code — should emit NOTHING
│   ├── monolith.rb                      # multi-smell kitchen sink
│   ├── feature_envy.rb                  # FeatureEnvy + UtilityFunction
│   ├── complex_router.rb                # HighComplexity + NestedIterators
│   ├── validator_a.rb / validator_b.rb  # structural duplication (flay)
│   ├── nested.rb                        # NestedIterators + DuplicateMethodCall
│   ├── params.rb                        # LongParameterList + BooleanParameter +
│   │                                    # ControlParameter + UncommunicativeParameterName
│   ├── names.rb                         # UncommunicativeMethod/Variable/ModuleName
│   ├── globals.rb                       # ClassVariable + TooManyConstants +
│   │                                    # TooManyInstanceVariables + TooManyMethods
│   ├── nilly.rb                         # NilCheck + MissingSafeMethod
│   ├── dispatch.rb                      # ManualDispatch
│   ├── dataclump.rb                     # DataClump + RepeatedConditional
│   ├── uninit.rb                        # InstanceVariableAssumption + ModuleInitialize
│   ├── unused.rb                        # UnusedParameters + UnusedPrivateMethod
│   ├── yields.rb                        # LongYieldList
│   ├── self_assign.rb                   # SelfAssignment
│   ├── attribute.rb                     # Attribute
│   └── singleton.rb                     # SingletonMethodCall
├── lib/
│   └── pre_existing.rb                  # smelly, committed BEFORE the PR — MUST NOT be flagged
├── configs/                             # swappable sample configs
│   ├── 00-empty.yml
│   ├── 01-filter-by-smell-types.yml
│   ├── 02-max-smells.yml
│   ├── 03-flay-threshold.yml
│   ├── 04-flog-threshold.yml
│   ├── 05-exclude-patterns.yml
│   ├── 06-complexity-max.yml
│   ├── 07-churn-max.yml
│   ├── 08-corrupt.yml
│   └── 09-non-hash.yml
└── scripts/
    └── demo-all.sh                      # runs every scenario and prints output
```

## Smell coverage matrix

Every category the RubyCritic analyser collection emits is represented:

| Analyser | Categories demonstrated | File(s) |
|---|---|---|
| **reek** | Attribute | `app/attribute.rb` |
| reek | BooleanParameter | `app/params.rb` |
| reek | ClassVariable | `app/globals.rb` |
| reek | ControlParameter | `app/params.rb` |
| reek | DataClump | `app/dataclump.rb` |
| reek | DuplicateMethodCall | `app/monolith.rb`, `app/nested.rb`, `app/validator_a.rb` |
| reek | FeatureEnvy | `app/feature_envy.rb` |
| reek | InstanceVariableAssumption | `app/uninit.rb` |
| reek | LongParameterList | `app/params.rb`, `app/monolith.rb` |
| reek | LongYieldList | `app/yields.rb` |
| reek | ManualDispatch | `app/dispatch.rb` |
| reek | MissingSafeMethod | `app/nilly.rb` |
| reek | ModuleInitialize | `app/uninit.rb` |
| reek | NestedIterators | `app/complex_router.rb`, `app/nested.rb` |
| reek | NilCheck | `app/nilly.rb` |
| reek | RepeatedConditional | `app/dataclump.rb` |
| reek | SelfAssignment | `app/self_assign.rb` |
| reek | SingletonMethodCall | `app/singleton.rb` |
| reek | TooManyConstants | `app/globals.rb` |
| reek | TooManyInstanceVariables | `app/globals.rb` |
| reek | TooManyMethods | `app/globals.rb` |
| reek | UncommunicativeMethodName | `app/names.rb`, `app/monolith.rb` |
| reek | UncommunicativeModuleName | `app/names.rb` |
| reek | UncommunicativeParameterName | `app/params.rb`, `app/names.rb` |
| reek | UncommunicativeVariableName | `app/names.rb`, `app/monolith.rb` |
| reek | UnusedParameters | `app/unused.rb` |
| reek | UnusedPrivateMethod | `app/unused.rb` |
| reek | UtilityFunction | `app/feature_envy.rb` |
| **flay** | Structural duplication | `app/validator_a.rb` + `app/validator_b.rb` |
| **flog** | High complexity score | `app/monolith.rb`, `app/complex_router.rb`, `app/nested.rb` |
| **complexity** | Cyclomatic complexity | `app/complex_router.rb` |
| **churn** | Git file churn | `lib/pre_existing.rb` (built up over commits) |
| **clean** | NOT flagged (baseline) | `app/clean.rb` |
| **pre-existing** | NOT flagged (diff scope) | `lib/pre_existing.rb` |

## Scenario matrix

Run any scenario locally via:

```bash
bundle install
git fetch origin main
scripts/demo-all.sh
```

Or run one scenario by swapping the config:

```bash
cp configs/03-flay-threshold.yml .rubycritic-pronto.yml
bundle exec pronto run -r rubycritic -c origin/main
```

| # | Scenario | Config / Env | Expected behaviour |
|---|---|---|---|
| 00 | Empty config | `configs/00-empty.yml` | Every smell reported, severity `:warning` |
| 01 | Allow-list reek smell types | `configs/01-filter-by-smell-types.yml` | Only FeatureEnvy / LongParameterList / DuplicateMethodCall kept |
| 02 | Cap smells per module | `configs/02-max-smells.yml` | Max 3 smells per module |
| 03 | Drop high-score flay | `configs/03-flay-threshold.yml` | flay smells with score > 30 dropped |
| 04 | Drop high-score flog | `configs/04-flog-threshold.yml` | flog smells with score > 10 dropped |
| 05 | Exclude by glob | `configs/05-exclude-patterns.yml` | `app/validator_*.rb` skipped for flay; `app/complex_*.rb` skipped for flog |
| 06 | Drop complex modules | `configs/06-complexity-max.yml` | Modules with complexity > 10 dropped entirely |
| 07 | Drop churn-heavy modules | `configs/07-churn-max.yml` | Modules with churn > 5 dropped entirely |
| 08 | Corrupt YAML | `configs/08-corrupt.yml` | `"pronto-rubycritic: invalid YAML..."` stderr, falls back to no filter |
| 09 | Non-Hash YAML | `configs/09-non-hash.yml` | `"must be a YAML mapping..."` stderr, falls back to no filter |
| 10 | Severity override | `PRONTO_RUBYCRITIC_SEVERITY_LEVEL=info` | All messages emitted at `:info` |
| 11 | Legacy env var | `PRONTO_REEK_SEVERITY_LEVEL=info` | Deprecation warning on stderr + value honoured |
| 12 | Debug mode | `PRONTO_RUBYCRITIC_DEBUG=1` | Backtrace head printed on errors |
| 13 | Raise-errors mode | `PRONTO_RUBYCRITIC_RAISE_ERRORS=1` | Runner re-raises instead of returning `[]` |
| 14 | GitHub formatter | `GITHUB_ACTIONS=1` | HTML `<details>` blocks |
| 15 | GitLab formatter | `GITLAB_CI=1` | Plain markdown (GitLab MR comments don't render `<details>`) |
| 16 | Pre-existing file not flagged | (any config) | `lib/pre_existing.rb` gets zero comments |
| 17 | Clean code not flagged | (any config) | `app/clean.rb` gets zero comments |

## What the GitHub PR shows

Open https://github.com/Rishabhs343/pronto-rubycritic-demo/pull/1 — the
Pronto workflow runs automatically, then posts:

- **Inline review comments** on every added smelly line
- Each comment contains: severity (W), smell type, method/class context,
  numeric metrics (complexity, duplication, methods, cost, churn),
  and a link to the upstream docs for the smell

`lib/pre_existing.rb` is never commented on, because the PR's diff doesn't
touch any of its lines — even though it contains obvious smells.

## What the GitLab MR shows

Pronto's `gitlab_mr` formatter renders plain-markdown inline MR discussion
threads. Set `PRONTO_GITLAB_API_PRIVATE_TOKEN` in `Project > Settings >
CI/CD > Variables` and open an MR against `main`.

## License

MIT
