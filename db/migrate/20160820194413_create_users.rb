class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_name, null: false
      t.string :slack_id, null: false\
    end
  end
end
