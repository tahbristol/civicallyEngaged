class CreateOfficials < ActiveRecord::Migration[5.1]
  def up
    create_table :officials do |t|
      t.string :name
      t.string :party
      t.string :phone
      t.string :url
      t.string :position
      t.string :photoUrl
    end
  end
end
