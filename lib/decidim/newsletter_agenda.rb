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
      "#7636D2"
    end

    # The default font color over background for the newsletter agenda.
    config_accessor :default_font_color_over_bg do
      "#FFFFFF"
    end

    # The default address text for the newsletter agenda.
    config_accessor :default_address_text do
      "<b>Canòdrom</b><br>" \
      "<b>Ateneu d'Innovació Digital i Democràtica</b><br>" \
      "C/Concepció Arenal 165<br>09027 Barcelona <a href='https://canodrom.barcelona'>canodrom.barcelona</a><br>" \
      "<a href='mailto:hola@canodrom.com'>hola@canodrom.com</a>"
    end

    # The additional social handlers for the newsletter agenda.
    config_accessor :additional_social_handlers do
      [:mastodon, :telegram, :peertube]
    end

    # To define the default first day for the agenda ranges.
    # This is the next monday:
    def self.next_first_day
      Date.current - Date.current.wday + 8
    end

    # To define the default last day for the agenda ranges.
    # This is the next sunday after the next monday:
    def self.next_last_day
      Date.current - Date.current.wday + 14
    end
  end
end
