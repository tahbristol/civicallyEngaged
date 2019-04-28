class AddEmailToOfficials < ActiveRecord::Migration[5.1]
    
    def change
        add_column :officials, :email, :string 
    end 
end 
