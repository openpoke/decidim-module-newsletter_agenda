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

          (1..4).each do |i|
            content_block.images << {
              name: :"body_box_image_#{i}",
              uploader: "Decidim::NewsletterTemplateImageUploader",
              preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
            }
          end

          (1..3).each do |i|
            content_block.images << {
              name: :"footer_box_image_#{i}",
              uploader: "Decidim::NewsletterTemplateImageUploader",
              preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
            }
          end

          content_block.settings do |settings|
            settings.attribute(
              :background_color,
              type: :text,
              preview: -> { Decidim::NewsletterAgenda.default_background_color || "#733BCE" }
            )
            settings.attribute(
              :font_color_over_bg,
              type: :text,
              preview: -> { Decidim::NewsletterAgenda.default_font_color_over_bg || "#FFFFFF" }
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
            settings.attribute(
              :intro_link_text,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_link_text_preview") }
            )
            settings.attribute(
              :intro_link_url,
              type: :text,
              translated: true,
              preview: -> { "https://decidim.org" }
            )
            settings.attribute(
              :body_title,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_title_preview") }
            )
            settings.attribute(
              :body_subtitle,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_subtitle_preview") }
            )
            settings.attribute(
              :boxes_number,
              type: :integer,
              preview: -> { 4 }
            )
            (1..4).each do |i|
              settings.attribute(
                "body_box_title_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_title_preview") }
              )
              settings.attribute(
                "body_box_date_time_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_date_time_preview") }
              )
              settings.attribute(
                "body_box_description_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_description_preview") }
              )
              settings.attribute(
                "body_box_link_text_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_link_text_preview") }
              )
              settings.attribute(
                "body_box_link_url_#{i}",
                type: :text,
                translated: true,
                preview: -> { "https://decidim.org" }
              )
            end
            settings.attribute(
              :body_final_text,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_final_text_preview") }
            )
            settings.attribute(
              :footer_title,
              type: :text,
              translated: true,
              preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_title_preview") }
            )
            (1..4).each do |i|
              settings.attribute(
                "footer_box_date_time_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_title_preview") }
              )
              settings.attribute(
                "footer_box_title_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_description_preview") }
              )
              settings.attribute(
                "footer_box_link_text_#{i}",
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_link_text_preview") }
              )
              settings.attribute(
                "footer_box_link_url_#{i}",
                type: :text,
                translated: true,
                preview: -> { "https://decidim.org" }
              )
              settings.attribute(
                :footer_address_text,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_address_text_preview") }
              )
            end
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
