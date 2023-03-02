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
      footer_image: Decidim::Dev.asset("city.jpeg")
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
      let!(:content_block_new) do
        content_block = Decidim::ContentBlock.find_by(organization: organization, scope_name: :newsletter_template, scoped_resource_id: newsletter.id, manifest_name: :agenda_events)
        content_block.destroy!
        content_block = create(
          :content_block,
          :newsletter_template,
          organization: organization,
          scoped_resource_id: newsletter.id,
          manifest_name: "agenda_events",
          settings: {
            body: Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title },
            introduction: Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title },
            intro_title: Decidim::Faker::Localized.word,
            intro_text: Decidim::Faker::Localized.word,
            body_box_link: I18n.available_locales.index_with { |_locale| Faker::Internet.url }
          }
        )
        content_block
      end

      before do
        fill_in :newsletter_subject_en, with: "subject"
        find('input[name="newsletter[settings][intro_title_en]"]').fill_in with: "Intro title"
        page.execute_script("document.querySelector('input[name=\"newsletter[settings][intro_text_en]\"]').value = 'Intro text';")
        find('input[name="newsletter[settings][intro_link_text_en]"]').fill_in with: "Intro link text"
        find('input[name="newsletter[settings][intro_link_url_en]"]').fill_in with: "http://www.example.org"
        find('input[name="newsletter[settings][body_title_en]"]').fill_in with: "Body title"
        find('input[name="newsletter[settings][body_subtitle_en]"]').fill_in with: "Body subtitle"
        find('select[name="newsletter[settings][boxes_number]"]').select("4")
        find("input[name='newsletter[settings][body_box_title_1_en]']").fill_in with: "Box title"
        find("input[name='newsletter[settings][body_box_date_time_1_en]']").fill_in with: 10.days.from_now.strftime("%d/%m/%Y")
        find("input[name='newsletter[settings][body_box_description_1_en]']").fill_in with: "Box description"
        find("input[name='newsletter[settings][body_box_link_text_1_en]']").fill_in with: "Box link text"
        find("input[name='newsletter[settings][body_box_link_url_1_en]']").fill_in with: "http://www.example.org"
        find("input[name='newsletter[settings][body_final_text_en]']").fill_in with: "Final text"
        find("input[name='newsletter[settings][footer_title_en]']").fill_in with: "Footer title"

        3.times do |i|
          find("input[name='newsletter[settings][footer_box_date_time_#{i + 1}_en]']").fill_in with: 5.days.from_now.strftime("%d/%m/%Y")
          find("input[name='newsletter[settings][footer_box_title_#{i + 1}_en]']").fill_in with: "Footer box title #{i + 1}"
          find("input[name='newsletter[settings][footer_box_link_text_#{i + 1}_en]']").fill_in with: "Footer box description #{i + 1}"
          find("input[name='newsletter[settings][footer_box_link_url_#{i + 1}_en]']").fill_in with: "http://www.example.org/footer"
          page.execute_script("document.querySelector('input[name=\"newsletter[settings][footer_address_text]\"]').value = 'Barcelona, Spain';")
        end

        click_button "Save"
      end

      it "renders the correct the settings form" do
        within_frame do
          expect(page).to have_content(translated("Intro title"))
          expect(page).to have_content(translated("Intro text"))
          expect(page).to have_content("Intro link text")
          expect(page).to have_css("a[href='http://www.example.org']")
          expect(page).to have_content(translated("Body title"))
          expect(page).to have_content(translated("Body subtitle"))
          expect(page).to have_content("Box title")
          expect(page).to have_content(10.days.from_now.strftime("%d/%m/%Y"))
          expect(page).to have_content("Box description")
          expect(page).to have_content("Box link text")
          expect(page).to have_css("a[href='http://www.example.org']")
          expect(page).to have_content(translated("Final text"))
          expect(page).to have_content(translated("Footer title"))

          (1..3).each do |i|
            expect(page).to have_content(5.days.from_now.strftime("%d/%m/%Y"), count: 3)
            expect(page).to have_content("Footer box title #{i}")
            expect(page).to have_content("Footer box description #{i}")
            expect(page).to have_css("a[href='http://www.example.org/footer']", count: 3)
          end

          expect(page).to have_content("Barcelona, Spain")
        end
      end
    end
  end
end
