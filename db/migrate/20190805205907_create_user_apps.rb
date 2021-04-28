class CreateUserApps < ActiveRecord::Migration
  def change
    create_table :user_apps do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :funcionarios, null: false

      t.timestamps
    end
  end
end
