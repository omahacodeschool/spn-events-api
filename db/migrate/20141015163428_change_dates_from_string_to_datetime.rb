class ChangeDatesFromStringToDatetime < ActiveRecord::Migration
  def change
    change_column :events, :event_date, :datetime
    change_column :events, :event_end, :datetime
  end
end
