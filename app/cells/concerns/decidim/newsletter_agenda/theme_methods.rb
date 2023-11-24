# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    module ThemeMethods
      extend ActiveSupport::Concern

      included do
        def theme
          @theme ||= begin
            manifest_name = model.respond_to?(:manifest_name) ? model.manifest_name : content_block.manifest_name
            manifest_name.gsub("_agenda_events", "").to_sym
          end
        end

        def social_handlers
          @social_handlers ||= NewsletterAgenda.social_handlers ||
                               NewsletterAgenda.themes&.dig(theme, :social_handlers) ||
                               []
        end

        def organization_handler_attributes
          @organization_handler_attributes ||= begin
            org = defined?(organization) ? organization : current_organization
            org.attributes.select { |key| key.to_s.include?("handler") }
          end
        end

        def link_color
          @link_color ||= model.settings.link_color.presence ||
                          default_link_color
        end

        def background_color
          @background_color ||= model.settings.background_color.presence ||
                                default_background_color
        end

        def font_color_over_bg
          @font_color_over_bg ||= model.settings.font_color_over_bg.presence ||
                                  default_font_color_over_bg
        end

        def default_link_color
          @default_link_color ||= NewsletterAgenda.default_link_color ||
                                  NewsletterAgenda.themes&.dig(theme, :default_link_color) ||
                                  current_organization.colors["primary"] ||
                                  "#39747f"
        end

        def default_background_color
          @default_background_color ||= NewsletterAgenda.default_background_color ||
                                        NewsletterAgenda.themes&.dig(theme, :default_background_color) ||
                                        current_organization.colors["primary"] ||
                                        "#39747f"
        end

        def default_font_color_over_bg
          @default_font_color_over_bg = NewsletterAgenda.default_font_color_over_bg ||
                                        NewsletterAgenda.themes&.dig(theme, :default_font_color_over_bg) ||
                                        "#FFFFFF"
        end

        def default_address_text
          @default_address_text ||= NewsletterAgenda.default_address_text ||
                                    NewsletterAgenda.themes.dig(theme, :default_address_text)
        end
      end
    end
  end
end
