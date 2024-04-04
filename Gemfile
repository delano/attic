# frozen_string_literal: true

source "https://rubygems.org"

ruby '>= 3.1'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# bundle install --without production
# bundle install --with development
# bundle install --without development
group "development" do
  gem "byebug"
  gem "pry"
  gem "pry-doc"
  gem "rubocop"
  gem "tryouts", '2.2.0.pre.RC1'
end
