class AddDateOfBirthToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :date_of_birth, :date
  end
end
