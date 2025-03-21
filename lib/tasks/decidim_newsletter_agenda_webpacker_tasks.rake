# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_newsletter_agenda do
  namespace :webpacker do
    desc "Installs Decidim Newsletter Agenda webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_newsletter_agenda_npm
    end

    desc "Adds Decidim Newsletter Agenda dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_newsletter_agenda_npm
    end

    def install_newsletter_agenda_npm
      newsletter_agenda_npm_dependencies.each do |type, packages|
        puts "install NPM packages. You can also do this manually with this command:"
        puts "npm i --save-#{type} #{packages.join(" ")}"
        system! "npm i --save-#{type} #{packages.join(" ")}"
      end
    end

    def newsletter_agenda_npm_dependencies
      @newsletter_agenda_npm_dependencies ||= begin
        package_json = JSON.parse(File.read(newsletter_agenda_path.join("package.json")))

        {
          prod: package_json["dependencies"].map { |package, version| "#{package}@#{version}" },
          dev: package_json["devDependencies"].map { |package, version| "#{package}@#{version}" }
        }.freeze
      end
    end

    def newsletter_agenda_path
      @newsletter_agenda_path ||= Pathname.new(newsletter_agenda_gemspec.full_gem_path) if Gem.loaded_specs.has_key?("decidim-newsletter_agenda")
    end

    def newsletter_agenda_gemspec
      @newsletter_agenda_gemspec ||= Gem.loaded_specs["decidim-newsletter_agenda"]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end
  end
end
