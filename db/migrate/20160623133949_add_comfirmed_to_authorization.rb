class AddComfirmedToAuthorization < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :confirmation_hash, :string
    add_column :authorizations, :confirmed, :boolean, default: false
  end
end
