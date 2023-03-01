# frozen_string_literal: true

require "spec_helper"

describe "Agenda events settings", type: :system do
  let(:organization_logo) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
  let(:footer_logo) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
  let(:organization) { create(:organization, logo: organization_logo, official_img_footer: footer_logo, colors: { "primary" => "#ef604d" }) }
  let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }
  let!(:newsletter) { create :newsletter, :sent, total_recipients: 1 }
  let!(:content_block) do
    create :content_block,
           organization: organization,
           manifest_name: :agenda_events,
           scope_name: :newsletter_template,
           scoped_resource_id: newsletter.id,
           settings: settings,
           images: images
  end

  let(:settings) do
    {
      background_color: organization.colors["primary"],
      font_color_over_bg: Decidim::NewsletterAgenda.default_font_color_over_bg,
      intro_title: "Intro title",
      intro_text: "Intro text",
      footer_address_text: Decidim::NewsletterAgenda.default_address_text
    }
  end

  let(:images) do
    {
      background_image: Decidim::Dev.asset("city2.jpeg"),
      footer_image: Decidim::Dev.asset("city2.jpeg"),
    }
  end

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin.root_path
    click_link "Newsletters"
  end

  describe "new newsletter" do
    before do
      page.all(:link, "New newsletter").first.click
      page.all(:link, "Use this template").last.click
    end

    context "when automatic customizable settings" do
      it "renders the correct the settings form" do
        expect(page).to have_content("Background color")
        expect(page).to have_field("newsletter[settings][background_color]", with: "#ef604d")
        expect(page).to have_content("Font color over background")
        expect(page).to have_field("newsletter[settings][font_color_over_bg]", with: "#ffffff")
        expect(page).to have_content("Organization address")
        expect(page.text.strip).to have_content(content_block.settings.footer_address_text.gsub(/\n/, " ").strip)
        expect(page).to have_content("Footer image")
      end
    end

    context "when settings from the form" do
      it "renders the correct the settings form" do

      end
    end
  end

  context "when everything ok" do
    it "renders the correct template" do
      click_link translated(newsletter.subject)
      expect(page).to have_content(translated(content_block.settings.intro_title))
      expect(page).to have_content(translated(content_block.settings.intro_text))
      expect(page).to have_css("img[src*='city2.jpeg']")
    end
  end
end
