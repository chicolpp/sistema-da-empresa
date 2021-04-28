class CreatePessoas < ActiveRecord::Migration
  def self.up
    create_table :pessoas do |t|
      t.string :nome, null: false
      t.boolean :tipo
      t.boolean :recebe_email, default: true
      t.boolean :recebe_sms, default: true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas
  end
end