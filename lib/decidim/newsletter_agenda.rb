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

    # The default font color over background for the newsletter agenda.
    config_accessor :default_font_color_over_bg do
      "#FFFFFF"
    end

    # The default address text for the newsletter agenda.
    config_accessor :default_address_text do
      <<~ADDRESS
        Canödrom
        Ateneu d'Innovació Digital i Democràtica
        C/Concepció Arenal 165 - 09027 Barcolana canodrom.barcelona
        hola@canodrom.com
      ADDRESS
    end
  end
end
