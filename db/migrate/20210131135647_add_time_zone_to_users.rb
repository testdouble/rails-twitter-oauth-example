class AddTimeZoneToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :time_zone, null: false, default: "UTC"
    end
  end
end
