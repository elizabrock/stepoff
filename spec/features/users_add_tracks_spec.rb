feature "Users add tracks" do
  before do
    pending
  end

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
    current_path.should == new_track_path
    pending
    do_more_stuff_here
  end

  scenario "sad path creating a track" do
    signin_as Fabricate(:user)
    pending
    do_more_stuff_here
  end
end
