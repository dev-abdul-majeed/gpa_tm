class AddQassFieldsToAssignment < ActiveRecord::Migration[8.0]
  def change
    change_table :assignments, bulk: true do |t|
      t.integer :lower_bound, default: 1
      t.integer :upper_bound, default: 7
      t.float :border_size, default: 0.003
      t.float :polarity_factor, default: 1.00
      t.float :group_spread, default: 0.50
    end
  end
end
