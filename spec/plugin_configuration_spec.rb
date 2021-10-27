require "spec_helper"

RSpec.describe "plugin configuration", type: :system do
  fixtures :projects, :users, 
           :email_addresses, 
           :roles, :members, 
           :member_roles,            
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :wikis,
           :wiki_pages,
           :wiki_contents

  before do
    log_user('admin', 'admin')
  end

  describe "disable SVG option" do    
    it "renders an error message instead of an SVG when SVG disabled" do
      Setting.plugin_redmine_drawio['drawio_disable_svg'] = true
      WikiContent.first.update!(text: "{{drawio_attach(new.svg)}}")
      visit "/projects/ecookbook/wiki"

      expect(page).to have_content("SVG support is deactivated, use png or xml instead")
      expect(page.all('svg').size).to  eq(0)
    end

    it "renders SVG when SVG is enabled" do
      Setting.plugin_redmine_drawio['drawio_disable_svg'] = false
      WikiContent.first.update!(text: "{{drawio_attach(new.svg)}}")
      visit "/projects/ecookbook/wiki"

      expect(page).not_to have_content("SVG support is deactivated, use png or xml instead")
      expect(page.all('svg').size).to  eq(1)
    end
  end
end
