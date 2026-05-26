# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    VERSION = "4.0"
    DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.31-stable" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.31", "< 0.32"].freeze
  end
end
