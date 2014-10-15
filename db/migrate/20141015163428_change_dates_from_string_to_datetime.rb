class ChangeDatesFromStringToDatetime < ActiveRecord::Migration
  def change
    remove_column :events, :event_date
    remove_column :events, :event_end
  end
end
