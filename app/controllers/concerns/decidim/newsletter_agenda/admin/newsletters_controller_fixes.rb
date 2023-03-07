# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    module Admin
      module NewslettersControllerFixes
        extend ActiveSupport::Concern

        included do
          # This is a fix for the newsletter controller to work properly with locales
          def preview
            enforce_permission_to :read, :newsletter, newsletter: newsletter
            user = current_user.dup
            user.locale = current_locale
            email = NewsletterMailer.newsletter(user, newsletter)
            Premailer::Rails::Hook.perform(email)

            render html: email.html_part.body.decoded.html_safe
          end
        end
      end
    end
  end
end
