class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :meaning
      t.string :word

      t.timestamps
    end

    create_table :roots_words do |t|
      t.belongs_to :root
      t.belongs_to :word
    end
  end
end
