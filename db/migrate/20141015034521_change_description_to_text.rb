class ChangeDescriptionToText < ActiveRecord::Migration
  def change
    change_column :events, :event_description, :text
  end
end
