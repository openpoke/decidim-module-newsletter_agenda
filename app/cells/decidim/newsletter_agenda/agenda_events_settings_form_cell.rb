# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    class AgendaEventsSettingsFormCell < NewsletterTemplates::BaseSettingsFormCell
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def settings
        @settings ||= form.object.settings.tap do |settings|
          settings[:background_color] ||= NewsletterAgenda.default_background_color || current_organization.colors["primary"] || "#7636D2"
          settings[:font_color_over_bg] ||= NewsletterAgenda.default_font_color_over_bg
          settings[:body_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_title_preview", locale: locale) if hash[locale].nil?
            end
          end
          settings[:body_subtitle].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day, Decidim::NewsletterAgenda.next_last_day) if hash[locale].nil?
            end
          end
          settings[:body_final_text].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_final_text_preview", locale: locale) if hash[locale].nil?
            end
          end
          settings[:footer_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_title_preview", locale: locale) if hash[locale].nil?
            end
          end
          settings[:footer_social_links_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_social_links_title_preview", locale: locale) if hash[locale].nil?
            end
          end
          settings[:footer_address_text] ||= NewsletterAgenda.default_address_text

          # social handlers
          Decidim::NewsletterAgenda.additional_social_handlers.each do |handler|
            settings["#{handler}_handler"] ||= ""
          end

          # boxes
          (1..4).each do |num|
            settings["body_box_link_text_#{num}"].tap do |hash|
              I18n.available_locales.each do |locale|
                hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_box_link_text_preview", locale: locale) if hash[locale].nil?
              end
            end
          end

          (1..3).each do |num|
            settings["footer_box_link_text_#{num}"].tap do |hash|
              I18n.available_locales.each do |locale|
                hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_box_link_text_preview", locale: locale) if hash[locale].nil?
              end
            end
          end
        end
      end

      def theme
        content_block.manifest_name.gsub("_agenda_events", "")
      end

      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
