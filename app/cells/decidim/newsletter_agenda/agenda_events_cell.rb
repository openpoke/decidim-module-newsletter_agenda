# frozen_string_literal: true

require "cell/partial"

module Decidim
  module NewsletterAgenda
    class AgendaEventsCell < NewsletterTemplates::BaseCell
      alias body show
      def show
        render :show
      end

      def intro_title
        parse_interpolations(uninterpolated(:intro_title), recipient_user, newsletter.id)
      end

      def intro_text
        parse_interpolations(uninterpolated(:intro_text), recipient_user, newsletter.id)
      end

      def uninterpolated(attribute)
        translated_attribute(model.settings.send(attribute))
      end

      def has_main_image?
        newsletter.template.images_container.main_image.attached?
      end

      def main_image
        image_tag main_image_url
      end

      def main_image_url
        newsletter.template.images_container.attached_uploader(:main_image).url(Rails.configuration.action_mailer.default_url_options.merge(host: organization.host))
      end

      def background_image_top
        asset_pack_url("media/images/background_top.gif") # , Rails.configuration.action_mailer.default_url_options.merge(host: organization.host))
      end

      def background_image_bottom
        asset_pack_url("media/images/background_bottom.gif") # , Rails.configuration.action_mailer.default_url_options.merge(host: organization.host))
      end

      def background_color
        model.settings.background_color.presence || NewsletterAgenda.default_background_color || organization.colors["primary"] || "#733BCE"
      end
    end
  end
end
