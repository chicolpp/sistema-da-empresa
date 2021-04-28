#encoding: utf-8
include Casein::ConfigHelper

$CASEIN_USER_ACCESS_LEVEL_ADMIN = 0
$CASEIN_USER_ACCESS_LEVEL_USER = 10
# $CASEIN_USER_ACCESS_LEVEL_FUNC_REPRE = 11
# $CASEIN_USER_ACCESS_LEVEL_RELATORIO = 12

module Casein
  class AdminUser < ActiveRecord::Base
    # belongs_to :pessoa
    belongs_to :cidade
    has_many :orcamentos
    has_many :usuario_cidades, dependent: :destroy
    
    # accepts_nested_attributes_for :pessoa, :reject_if => :all_blank, :allow_destroy => true
    accepts_nested_attributes_for :usuario_cidades, :reject_if => :all_blank, :allow_destroy => true

	  def self.table_name
      self.to_s.gsub("::", "_").tableize
    end

    acts_as_authentic { |c| c.validate_email_field = false }

    attr_accessor :notify_of_new_password

    after_create :send_create_notification
    after_update :send_update_notification
    before_validation :check_time_zone

    validates_presence_of :login, :email#, :pos_venda, :access_level#, :name
    validates_uniqueness_of :login
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    #validates_presence_of :time_zone

  	def self.has_more_than_one_admin
      Casein::AdminUser.where(:access_level => $CASEIN_USER_ACCESS_LEVEL_ADMIN).count > 1
    end

  	def send_create_notification
      #Casein::CaseinNotification.new_user_information(casein_config_email_from_address, self, casein_config_hostname, @password).deliver
    end

    def send_update_notification
      if notify_of_new_password
        notify_of_new_password = false
        #Casein::CaseinNotification.generate_new_password(casein_config_email_from_address, self, casein_config_hostname, @password).deliver
      end
    end

    def send_password_reset_instructions
      # reset_perishable_token!
      # Casein::CaseinNotification.password_reset_instructions(casein_config_email_from_address, self, casein_config_hostname).deliver
    end

    def check_time_zone
      self.time_zone = Rails.configuration.time_zone unless self.time_zone
    end

  	def is_admin?
  	  access_level == $CASEIN_USER_ACCESS_LEVEL_ADMIN
  	end

    # before_create do
    #   self.access_level = $CASEIN_USER_ACCESS_LEVEL_USER
    # end

    scope :access_level, -> access_level { where(access_level: access_level) }
  end
end
