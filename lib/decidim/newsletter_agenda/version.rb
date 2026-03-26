# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    VERSION = "2.1"
    DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.30-stable" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.30", "< 0.32"].freeze
  end
end
