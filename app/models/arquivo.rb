class Arquivo < ActiveRecord::Base
  audited
  
	belongs_to :owner, polymorphic: true

  has_attached_file :upload

  validates_attachment_content_type :upload, :content_type => [ /\Aimage\/.*\Z/, "application/pdf","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf"]

  validates_attachment_size :upload, :in => 0..15.megabytes
end