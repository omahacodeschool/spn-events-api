class AddEventDateAndEventEndColumns < ActiveRecord::Migration
  def change
    add_column :events, :event_date, :datetime
    add_column :events, :event_end, :datetime
  end
end
