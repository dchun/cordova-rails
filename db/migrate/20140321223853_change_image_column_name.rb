class ChangeImageColumnName < ActiveRecord::Migration
  def change
    rename_column :images, :image, :pic
  end
end
