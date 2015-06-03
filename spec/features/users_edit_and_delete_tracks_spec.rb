feature "Users edit and delete tracks" do
  let!(:track){ Fabricate(:track, name: "Thunderrome", distance: 100, outdoor: true) }

  scenario "user must be logged in to edit/delete a track" do
    visit tracks_path
    page.should_not have_content("Edit")
    page.should_not have_content("Delete")
    visit edit_track_path(track)
    current_path.should == root_path
    page.should have_css(".alert", text: "You must be logged in to view that page.")
  end

  scenario "happy path editing a track" do
    signin_as Fabricate(:user)
    visit tracks_path
    click_on "Edit"
    field_labeled("Name").value.should == "Thunderrome"
    field_labeled("Distance").value.should == "100.0"
    field_labeled("Outdoors").should be_checked
    fill_in "Name", with: "Thunderdome"
    fill_in "Distance", with: 0.5
    uncheck "Outdoors"
    click_on "Save Changes"
    current_path.should == tracks_path
    page.should have_css(".notice", text: "Thunderdome Track was updated successfully")
    page.should have_content("Thunderdome, 0.5 mile indoors")
  end

  scenario "sad path editing a track" do
    signin_as Fabricate(:user)
    visit tracks_path
    click_on "Edit"
    fill_in "Name", with: "TD"
    fill_in "Distance", with: "-0.5"
    click_on "Save Changes"
    page.should have_css(".alert", text: "Please fix the errors below to continue.")
    field_labeled("Name").value.should == "TD"
    field_labeled("Distance").value.should == "-0.5"
    field_labeled("Outdoors").should be_checked
    page.should have_css(".track_name .error", text: "should have at least 3 characters")
    page.should have_css(".track_distance .error", text: "must be greater than or equal to 0.1")
  end

  scenario "deleting a track" do
    pending
    signin_as Fabricate(:user)
    visit tracks_path
    page.should have_content("Thunderrome")
    click_on "Delete"
    page.should have_notice("Thunderrome Track has been deleted.")
    within("ul#walking_tracks") do
      page.should_not have_content("Thunderrome")
    end
  end
end
