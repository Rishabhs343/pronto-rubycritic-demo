# frozen_string_literal: true

source 'https://rubygems.org'

# base64 left stdlib in Ruby 3.4; pronto's transitive dep chain still needs it.
gem 'base64', '~> 0.2'
gem 'pronto', '>= 0.11', '< 2.0'

# pronto-rubycritic is pulled from GitHub until it's published to RubyGems.
gem 'pronto-rubycritic',
    git: 'https://github.com/Rishabhs343/custom-pronto-gem.git',
    branch: 'main'

group :development, :test do
  gem 'rake', '~> 13.0'
end
