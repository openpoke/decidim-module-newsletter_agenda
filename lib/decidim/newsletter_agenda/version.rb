# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    VERSION = "2.0"
    DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.29-stable" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.29", "< 0.30"].freeze
  end
end
