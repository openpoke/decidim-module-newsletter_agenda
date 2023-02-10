# frozen_string_literal: true

require "decidim/newsletter_agenda/engine"

module Decidim
  # This namespace holds the logic of the `decidim-newsletter_agenda` module.
  module NewsletterAgenda
    include ActiveSupport::Configurable

    # The default background color for the newsletter agenda.
    # leave it empty (nil) to use the configured organization's main color.
    # this color can be overriden in the newsletter template builder.
    # hex color code with #, e.g. "#733BCE"
    config_accessor :default_background_color do
      nil
    end
  end
end
