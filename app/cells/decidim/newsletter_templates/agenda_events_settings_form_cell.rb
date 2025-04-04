# frozen_string_literal: true

module Decidim
  module NewsletterTemplates
    class AgendaEventsSettingsFormCell < BaseSettingsFormCell
      include ThemeMethods

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def settings
        @settings ||= form.object.settings.tap do |settings|
          settings[:link_color] ||= default_link_color
          settings[:background_color] ||= default_background_color
          settings[:font_color_over_bg] ||= default_font_color_over_bg
          localize_setting(settings[:body_title]) do |locale|
            I18n.t("decidim.newsletter_templates.agenda_events.body_title_preview", locale:)
          end

          localize_setting(settings[:body_subtitle]) do
            DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day, Decidim::NewsletterAgenda.next_last_day)
          end

          localize_setting(settings[:body_final_text]) do |locale|
            I18n.t("decidim.newsletter_templates.agenda_events.body_final_text_preview", locale:)
          end

          localize_setting(settings[:footer_title]) do |locale|
            I18n.t("decidim.newsletter_templates.agenda_events.footer_title_preview", locale:)
          end

          localize_setting(settings[:footer_social_links_title]) do |locale|
            I18n.t("decidim.newsletter_templates.agenda_events.footer_social_links_title_preview", locale:)
          end

          settings[:footer_address_text] = default_address_text if settings[:footer_address_text].blank?

          # social handlers
          social_handlers&.each do |handler, default|
            settings["#{handler}_handler"] ||= organization_handler_attributes["#{handler}_handler"] || default
          end

          # boxes
          (1..4).each do |num|
            localize_setting(settings["body_box_link_text_#{num}"]) do |locale|
              I18n.t("decidim.newsletter_templates.agenda_events.body_box_link_text_preview", locale:)
            end
          end

          (1..3).each do |num|
            localize_setting(settings["footer_box_link_text_#{num}"]) do |locale|
              I18n.t("decidim.newsletter_templates.agenda_events.footer_box_link_text_preview", locale:)
            end
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      private

      def localize_setting(setting)
        setting.tap do |hash|
          hash = {} unless hash.is_a?(Hash)
          I18n.available_locales.each do |locale|
            hash[locale] = yield(locale) if hash[locale].nil?
          end
        end
      end
    end
  end
end
