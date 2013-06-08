class CreateCustomDrones < ActiveRecord::Migration
  def change
    create_table :custom_drones do |t|
      t.string :slug, :limit => 100
      t.string :name, :limit => 200
      t.string :category, :limit => 25
      t.text :description
      t.string :git_url, :limit => 250
      t.string :git_revision, :limit => 40
      t.timestamps
    end
  end
end
