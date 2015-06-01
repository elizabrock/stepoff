feature "User Signs Up" do

  background do
    visit root_path
    click_on "Sign Up"
  end

  scenario "Happy Path" do
    fill_in "Name", with: "Joe"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "password1"
    fill_in "Password confirmation", with: "password1"
    click_on "Sign Up"
    page.should have_content("Welcome, Joe")
    User.last.tap do |user|
      user.name.should == "Joe"
      user.email.should == "joe@example.com"
    end
    pending
    signout
    signin_as "joe@example.com", "password1"
  end

  scenario "Error Path" do
    fill_in "Name", with: ""
    fill_in "Email", with: "joeexample.com"
    fill_in "Password", with: "password1"
    fill_in "Password confirmation", with: "food"
    click_on "Sign Up"
    page.should have_css(".alert", text: "Please fix the errors below to continue.")

    page.should have_css(".user_name .error", text: "can't be blank")
    page.should have_css(".user_email .error", text: "must be an email address")
    page.should have_css(".user_password_confirmation .error", text: "doesn't match Password")

    fill_in "Name", with: "Sally"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "password1"
    fill_in "Password confirmation", with: "password1"
    click_on "Sign Up"
    page.should have_content("Welcome, Sally")
  end

  scenario "Already registered" do
    Fabricate(:user, name: "Susan", email: "susie@example.com", password: "ThisIsAwesome", password_confirmation: "ThisIsAwesome")
    fill_in "Email", with: "susie@example.com"
    fill_in "Name", with: "Susie"
    fill_in "Password", with: "password1"
    fill_in "Password confirmation", with: "password1"
    click_on "Sign Up"
    pending
    page.should have_content("You already have an account. Please sign in.")
    field_labeled("Email").value.should == "susie@example.com"
    fill_in("Password", with: "ThisIsAwesome")
    click_on "Sign In"
    page.should have_content("Welcome, Susan")
  end
end
