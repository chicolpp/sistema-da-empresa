class Foto < ActiveRecord::Base
	audited

  belongs_to :casein_admin_user, class_name: "Casein::AdminUser"
  belongs_to :poco

  has_attached_file :foto, :styles => { :grande => "1000x1000>", :media => "400x400>", :thumb => "100x100#", :dashboard => "250x250#{}" }

  validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/

  validates_attachment_presence :foto
  validates_attachment_size :foto, :in => 0..15.megabytes
end