require 'rails_helper'

RSpec.describe Lap, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :track }
  describe "laps should be properly spaced" do
    let(:user){ Fabricate(:user) }
    let(:track){ Fabricate(:track) }
    let(:current_lap){ Fabricate.build(:lap, user: user, track: track) }
    context "if the last lap for this user was too recent" do
      before do
        track.stub(:minimum_completion_time).and_return(60)
        Fabricate(:lap, user: user, created_at: 45.seconds.ago)
      end

      it "shouldn't allow a new lap" do
        current_lap.should_not be_valid
      end

      it "should have errors on base" do
        current_lap.save
        current_lap.errors[:base].should == ["is too soon"]
      end
    end
    context "if the last lap for this user was long enough ago" do
      before do
        track.stub(:minimum_completion_time).and_return(40)
        Fabricate(:lap, user: user, created_at: 45.seconds.ago)
      end

      it "should allow a new lap" do
        current_lap.should be_valid
      end
    end
    context "if this is the user's first lap" do
      it "should allow a new lap" do
        current_lap.should be_valid
      end
    end
    context "if a different user has a recent lap" do
      let(:other_user){ Fabricate(:user) }
      before do
        track.stub(:minimum_completion_time).and_return(60)
        Fabricate(:lap, user: other_user, created_at: 45.seconds.ago)
      end

      it "should allow a new lap for this user" do
        current_lap.should be_valid
      end
    end
  end
end
