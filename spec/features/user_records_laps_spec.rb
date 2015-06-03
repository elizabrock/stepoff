feature "User records laps" do
  before do
    pending
  end

  scenario "an example of time traveling" do
    user = Fabricate(:user)
    Fabricate(:track, name: "Around Building", distance: 0.2)
    Fabricate(:track, name: "To Bathroom", distance: 0.1)
    signin_as user
    click_on "Start Walking"
    current_path.should == new_lap_path
    select "Around Building", from: "Track"
    click_on "Record Lap"
    page.should have_css(".notice", "Your lap Around Building has been recorded")
    current_path.should == new_lap_path
    field_labeled("Track").value.should == "Around Building"
    Timecop.travel_to(90.seconds.from_now) do
      click_on "Record Lap"
      page.should have_css(".notice", "Your lap Around Building has been recorded")
    end
    visit root_path
    page.should have_content("You have traveled 0.4 miles")
  end

  scenario "happy path, walking a track multiple times"
  scenario "cheating *@# path"
end
