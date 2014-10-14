class CreateSpnEvents < ActiveRecord::Migration
  def change
    create_table :spn_events do |t|
      t.string :name
      t.string :date
      t.string :time
      t.string :location
      t.string :url

      t.timestamps
    end
  end
end
