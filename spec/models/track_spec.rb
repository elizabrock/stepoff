require 'rails_helper'

RSpec.describe Track, type: :model do
  describe "validations" do
    after(:each) do
      described_class.destroy_all
    end
    it "should be invalid without a name" do
      Fabricate.build(:track, name: nil).should_not be_valid
    end
    it "should be invalid if name is all whitespace" do
      Fabricate.build(:track, name: "         ").should_not be_valid
    end
    it "should be invalid if name is <= 2 chars" do
      Fabricate.build(:track, name: "tu").should_not be_valid
    end
    it "should be invalid without a distance" do
      Fabricate.build(:track, distance: nil).should_not be_valid
    end
    it "should be invalid without a outdoor value" do
      Fabricate.build(:track, outdoor: nil).should_not be_valid
    end
    it "should have unique names" do
      some_name = Faker::Name.name
      Fabricate(:track, name: some_name)
      Fabricate.build(:track, name: some_name).should_not be_valid
    end
    it "should round distances to the nearest hundredth" do
      track1 = Fabricate(:track, distance: 0.265)
      track1.distance.should eq(0.27)
    end
    it "should be invalid if distance is < 0.1" do
      Fabricate.build(:track, distance: -0.5).should_not be_valid
    end
  end
  it "should have a factory" do
    Fabricate.build(:track).should be_valid
  end
end
