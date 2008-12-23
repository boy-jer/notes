class NotableSchemaV1 < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :user_id, :integer
      t.column :description, :text
      t.column :date, :date
      t.column :favorite, :integer
      t.column :color, :string
      t.column :x, :integer
      t.column :y, :integer
      t.column :z, :integer
    end

    create_table :taggings do |t| 
      t.column :taggable_id, :integer 
      t.column :user_id, :integer
      t.column :tag_id, :integer 
      t.column :taggable_type, :string 
    end

    create_table :tags do |t| 
      t.column :user_id, :integer
      t.column :name, :string 
      t.column :color, :string, :default=>"yellow"
    end

    create_table :note_files do |t|
      t.column :note_id, :integer
      t.column :filename, :string
      t.column :systempath, :string
      t.column :filetype, :string
    end

    create_table :users do |t|
      t.column :login, :string, :default => nil
      t.column :password, :string, :default => nil
    end

  end

  def self.down
    drop_table :notes
    drop_table :taggings
    drop_table :tags
    drop_table :note_files
    drop_table :users
  end

end
