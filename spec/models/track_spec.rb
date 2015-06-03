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

  describe "#minimum_completion_time calculates time based on 7.5 minute mile" do
    it "works for a small track" do
      track = Fabricate(:track, distance: 0.1)
      track.minimum_completion_time.should == 45
    end
    it "works for a long track" do
      track = Fabricate(:track, distance: 1)
      track.minimum_completion_time.should == 450
    end
    it "doesn't explode with negative distance" do
      track = Fabricate.build(:track, distance: -1)
      track.minimum_completion_time.should be_nil
    end
    it "doesn't explode with 0 distance" do
      track = Fabricate.build(:track, distance: 0)
      track.minimum_completion_time.should be_nil
    end
    it "doesn't explode with nil distance" do
      track = Fabricate.build(:track, distance: nil)
      track.minimum_completion_time.should be_nil
    end
  end
end
