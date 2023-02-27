# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    class AgendaEventsSettingsFormCell < NewsletterTemplates::BaseSettingsFormCell
      def background_color
        model.object.settings[:background_color].presence || NewsletterAgenda.default_background_color || current_organization.colors["primary"] || "#733BCE"
      end

      def font_color_over_bg
        model.object.settings[:font_color_over_bg].presence || NewsletterAgenda.default_font_color_over_bg || "#FFFFFF"
      end
    end
  end
end
