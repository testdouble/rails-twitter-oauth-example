class AddDraftToToot < ActiveRecord::Migration[6.1]
  def change
    change_table :toots do |t|
      t.boolean :draft, null: false, default: false
    end
  end
end
