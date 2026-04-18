# pronto-rubycritic-demo

A tiny Ruby project that demonstrates [pronto-rubycritic](https://github.com/Rishabhs343/custom-pronto-gem)
running against a real pull request.

## What's inside

```
.
├── .github/workflows/pronto.yml      # runs pronto-rubycritic on every PR
├── .gitlab-ci.yml                     # runs pronto-rubycritic on every MR
├── .rubycritic-pronto.yml             # runner filter config
├── Gemfile                            # pulls the gem from GitHub
├── app/
│   ├── clean.rb                       # clean code baseline
│   ├── monolith.rb                    # LongParameterList + DuplicateMethodCall + HighComplexity
│   ├── feature_envy.rb                # FeatureEnvy + TooManyStatements
│   ├── complex_router.rb              # HighComplexity + DuplicateMethodCall
│   ├── validator_a.rb                 # Structural duplication (with validator_b)
│   └── validator_b.rb                 # Structural duplication (with validator_a)
└── lib/
    └── pre_existing.rb                # smelly, but committed BEFORE the PR — must NOT be flagged
```

## How the demo is structured

The `main` branch starts with only `lib/pre_existing.rb` (a file that already has many smells,
representing "legacy code that was there before this PR").

A feature branch (`feat/add-smelly-code`) then adds six new files under `app/` that together
trigger **every** RubyCritic analyser category:

| File | Triggers |
|---|---|
| `monolith.rb` | LongParameterList, DuplicateMethodCall, HighComplexity, UncommunicativeMethodName |
| `feature_envy.rb` | FeatureEnvy, TooManyStatements, UtilityFunction |
| `complex_router.rb` | HighComplexity, NestedIterators, DuplicateMethodCall |
| `validator_a.rb` | Structural duplication (flay) with `validator_b.rb` |
| `validator_b.rb` | Structural duplication (flay) with `validator_a.rb` |
| `clean.rb` | *(no smells — proves clean code is not flagged)* |

When the PR is opened, `pronto-rubycritic` runs in CI and comments on each added/changed
line that has a smell. `lib/pre_existing.rb` is **not** flagged because the PR did not
touch any of its lines.

## Run locally

```bash
bundle install
git fetch origin main
bundle exec pronto run -r rubycritic -c origin/main
```

## Filter config (optional)

`.rubycritic-pronto.yml`:

```yaml
reek:
  smell_types:
    - FeatureEnvy
    - LongParameterList
    - DuplicateMethodCall
  max_smells: 5
flay:
  max_score: 100
flog:
  max_score: 20
```

## License

MIT
