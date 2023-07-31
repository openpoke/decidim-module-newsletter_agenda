# frozen_string_literal: true

require "decidim/dev/common_rake"
require "fileutils"

def seed_db(path)
  # maintain until https://github.com/decidim/decidim/commit/51b81b37004708ab72e70993fef4634eef18ee6c is in the decidim version used
  FileUtils.cp("babel.config.json", "#{path}/babel.config.json")
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  seed_db("development_app")
end
