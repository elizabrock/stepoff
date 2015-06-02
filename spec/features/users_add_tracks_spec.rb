feature "Users add tracks" do

  scenario "user must be logged in to create a track" do
    visit tracks_path
    page.should_not have_content("Add New Track")
    visit new_track_path
    current_path.should == root_path
    page.should have_css(".alert", text: "You must be logged in to view that page.")
  end

  scenario "happy path creating a track" do
    signin_as Fabricate(:user)
    visit tracks_path
    click_on "Add New Track"
    fill_in "Name", with: "To The Supermercado"
    fill_in "Distance", with: "1.0"
    check "Outdoors"
    click_on "Create Track"
    page.should have_css(".notice", text: "The To The Supermercado Track has been created")
    current_path.should == tracks_path
    within("ul#walking_tracks") do
      page.should have_content("To The Supermercado, 1.0 mile outdoors")
    end
  end

  scenario "sad path creating a track" do
    signin_as Fabricate(:user)
    visit new_track_path
    fill_in "Name", with: "bo"
    fill_in "Distance", with: "0.05"
    # uncheck "Outdoor" is implied
    click_on "Create Track"
    page.should have_css(".alert", text: "Please fix the errors below to continue.")
    page.should have_css(".track_name .error", text: "should have at least 3 characters")
    page.should have_css(".track_distance .error", text: "must be greater than or equal to 0.1")
    page.should_not have_css(".track_outdoor .error")
    field_labeled("Name").value.should == "bo"
    field_labeled("Distance").value.should == "0.05"
    field_labeled("Outdoors").should_not be_checked
  end
end
