# frozen_string_literal: true

require "cell/partial"

module Decidim
  module NewsletterAgenda
    class AgendaEventsCell < NewsletterTemplates::BaseCell
      alias body show

      def show
        render :show
      end

      def organization_logo
        organization.name
      end

      def intro_title
        parse_interpolations(uninterpolated(:intro_title), recipient_user, newsletter.id)
      end

      def intro_text
        parse_interpolations(uninterpolated(:intro_text), recipient_user, newsletter.id)
      end

      def intro_link_text
        parse_interpolations(uninterpolated(:intro_link_text), recipient_user, newsletter.id)
      end

      def intro_link_url
        translated_attribute(model.settings.intro_link_url)
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

      def body_title
        parse_interpolations(uninterpolated(:body_title), recipient_user, newsletter.id)
      end

      def body_subtitle
        parse_interpolations(uninterpolated(:body_subtitle), recipient_user, newsletter.id)
      end

      def body_final_text
        parse_interpolations(uninterpolated(:body_final_text), recipient_user, newsletter.id)
      end

      def boxes_number
        model.settings.boxes_number.to_i
      end

      def body_box_title(box_number)
        parse_interpolations(uninterpolated("body_box_title_#{box_number}"), recipient_user, newsletter.id)
      end

      def body_box_date_time(box_number)
        parse_interpolations(uninterpolated("body_box_date_time_#{box_number}"), recipient_user, newsletter.id)
      end

      def body_box_description(box_number)
        parse_interpolations(uninterpolated("body_box_description_#{box_number}"), recipient_user, newsletter.id)
      end

      def body_box_link_text(box_number)
        parse_interpolations(uninterpolated("body_box_link_text_#{box_number}"), recipient_user, newsletter.id)
      end

      def body_box_link_url(box_number)
        translated_attribute(model.settings["body_box_link_url_#{box_number}"])
      end

      def body_box_image(box_number)
        image_tag body_box_image_url(box_number)
      end

      def body_box_image_url(box_number)
        newsletter.template.images_container.attached_uploader.send("body_box_image_#{box_number}")
                  .url(Rails.configuration.action_mailer.default_url_options.merge(host: organization.host))
      end

      def has_box_image?(box_number)
        newsletter.template.images_container.send("body_box_image_#{box_number}").attached?
      end

      # Footer
      def footer_title
        parse_interpolations(uninterpolated(:footer_title), recipient_user, newsletter.id)
      end

      def footer_box_title(box_number)
        parse_interpolations(uninterpolated("footer_box_title_#{box_number}"), recipient_user, newsletter.id)
      end

      def footer_box_date_time(box_number)
        parse_interpolations(uninterpolated("footer_box_date_time_#{box_number}"), recipient_user, newsletter.id)
      end

      def footer_box_link_text(box_number)
        parse_interpolations(uninterpolated("footer_box_link_text_#{box_number}"), recipient_user, newsletter.id)
      end

      def footer_box_link_url(box_number)
        translated_attribute(model.settings["footer_box_link_url_#{box_number}"])
      end
    end
  end
end
