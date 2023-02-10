# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    # This is the engine that runs on the public interface of decidim-newsletter_agenda.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::NewsletterAgenda

      initializer "decidim-newsletter_agenda.newsletter_templates" do
        Decidim.content_blocks.register(:newsletter_template, :agenda_events) do |content_block|
          content_block.cell = "decidim/newsletter_agenda/agenda_events"
          content_block.settings_form_cell = "decidim/newsletter_agenda/agenda_events_settings_form"
          content_block.public_name_key = "decidim.newsletter_templates.agenda_events.name"

          content_block.images = [
            {
              name: :main_image,
              uploader: "Decidim::NewsletterTemplateImageUploader",
              preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
            },
            {
              name: :footer_image,
              uploader: "Decidim::NewsletterTemplateImageUploader",
              preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/decidim-logo.svg") }
            }
          ]

          content_block.settings do |settings|
            settings.attribute(
              :background_color,
              type: :text,
              preview: -> { Decidim::NewsletterAgenda.default_background_color || "#733BCE" }
            )
            settings.attribute(
              :intro_title,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_title_preview") }
            )
            settings.attribute(
              :intro_text,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_text_preview") }
            )
          end

          content_block.default!
        end
      end

      initializer "decidim-newsletter_agenda.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NewsletterAgenda::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NewsletterAgenda::Engine.root}/app/views") # for partials
      end

      initializer "decidim-newsletter_agenda.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
