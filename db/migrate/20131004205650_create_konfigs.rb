class CreateKonfigs < ActiveRecord::Migration
  def change
    create_table :konfigs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
