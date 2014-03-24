class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :pic
      t.belongs_to :job, index: true
    end
  end
end
