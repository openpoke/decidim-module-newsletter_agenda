# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    module Admin
      module FixNewsletterPreviewLocales
        extend ActiveSupport::Concern

        included do
          before_action only: :preview do
            # This is a fix for the newsletter controller to work properly with locales
            current_user.locale = current_locale
          end
        end
      end
    end
  end
end
