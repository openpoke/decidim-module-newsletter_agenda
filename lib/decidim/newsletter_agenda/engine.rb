# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    # This is the engine that runs on the public interface of decidim-newsletter_agenda.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::NewsletterAgenda

      initializer 'decidim-newsletter_agenda.webpacker.assets_path' do
        Decidim.register_assets_path File.expand_path('app/packs', root)
      end
    end
  end
end
