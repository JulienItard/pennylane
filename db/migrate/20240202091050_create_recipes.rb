class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :budget
      t.integer :difficulty
      t.interval :prep_time
      t.interval :cook_time
      t.interval :total_time
      t.integer :people_quantity
      t.string :author
      t.string :author_tip
      t.string :image
      t.integer :nb_comments
      t.float :rate

      t.timestamps
    end

    # Search indexes
    add_index :recipes, :name
    add_index :recipes, :budget
    add_index :recipes, :difficulty

    # Sorting indexes
    add_index :recipes, :total_time
    add_index :recipes, :nb_comments
    add_index :recipes, :rate
  end
end
