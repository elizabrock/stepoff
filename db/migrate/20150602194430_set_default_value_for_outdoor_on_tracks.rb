class SetDefaultValueForOutdoorOnTracks < ActiveRecord::Migration
  def up
    change_column :tracks, :outdoor, :boolean, default: false
  end

  def down
    change_column :tracks, :outdoor, :boolean, default: nil
  end
end
