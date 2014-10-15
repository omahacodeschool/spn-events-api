class ChangeSpnEventTableToEventTable < ActiveRecord::Migration
  def change
    drop_table :spn_events
    create_table :events do |t|
      t.string :event_name
      t.string :event_url
      t.string :event_date
      t.string :event_end
      t.string :event_author
      t.string :event_address
      t.string :event_state
      t.string :event_zip_code
      t.string :event_description
      t.string :event_origin
    end
  end
end
