class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :organizer, null: false #creator's slack handle
      t.string :lookup_name, null: false, unique: true
      t.string :venue, null: false
      t.datetime :starts_at, null: false
      #Set this programatically, 12 hrs after start time
      t.datetime :expires_at, null: false
      #array of attendee's slack handles
      t.string :members, array: true, default: []
    end
  end
end
