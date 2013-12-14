class CreateRoots < ActiveRecord::Migration
  def change
    create_table :roots do |t|
      t.string :root_db
      t.string :root
      t.string :meaning
      t.string :origin

      t.timestamps
    end
  end
end
