# casein_text_field form, obj, attribute, options = {}
# casein_password_field form, obj, attribute, options = {}
# casein_text_area form, obj, attribute, options = {}
# casein_text_area_big form, obj, attribute, options = {}
# casein_check_box form, obj, attribute, options = {}
# casein_check_box_group form, obj, check_boxes = {}
# casein_radio_button form, obj, attribute, tag_value, options = {}
# casein_radio_button_group form, obj, radio_buttons = {}
# casein_select form, obj, attribute, option_tags, options = {}
# casein_time_zone_select form, obj, attribute, option_tags, options = {}
# casein_collection_select form, obj, object_name, attribute, collection, value_method, text_method, options = {}
# casein_date_select form, obj, attribute, options = {}
# casein_time_select form, obj, attribute, options = {}
# casein_datetime_select form, obj, attribute, options = {}
# casein_file_field form, obj, object_name, attribute, options = {}
# casein_hidden_field form, obj, attribute, options = {}
# casein_custom_field form, obj, attribute, custom_contents, options = {}

module Casein
  module ConfigHelper

    # Name of website or client — used throughout Casein.
    def casein_config_website_name
      "#{ENV['SYSTEM_NAME']} - Sistema"
    end

    # Filename of logo image. Ideally, it should be a transparent PNG around 140x30px
    def casein_config_logo
      'materiaguas.png'
    end

    # The server hostname where Casein will run
    def casein_config_hostname
      if Rails.env.production?
        'http://sistema.materiaguas.com.br'
      else
        'http://localhost:3000'
      end
    end

    # The sender address used for email notifications
    def casein_config_email_from_address
      ENV['SMTP_EMAIL_FROM']
    end

    # The initial page the user is shown after they sign in or click the logo. Probably this should be set to the first tab.
    # Do not point this at casein/index!
    def casein_config_dashboard_url
      url_for casein_dashboard_url
    end

    # A list of stylesheets to include. Do not remove the core casein/casein, but you can change the load order, if required.
    def casein_config_stylesheet_includes
      %w[casein/casein casein/custom]
    end

    # A list of JavaScript files to include. Do not remove the core casein/casein, but you can change the load order, if required.
    def casein_config_javascript_includes
      %w[casein/casein casein/custom]
    end

    def acesso_por_cidade(escopos_model, campo, tabela, id)
      if campo.blank? && id.present?
        return escopos_model.joins("JOIN usuario_cidades AS uc ON uc.cidade_id = #{tabela}.cidade_id AND uc.admin_user_id = '#{current_user.id}'").where(id: id).first
      else
        return escopos_model.order("#{campo}").joins("JOIN usuario_cidades AS uc ON uc.admin_user_id = '#{current_user.id}' AND uc.cidade_id = #{tabela}.cidade_id")
      end
    end
  end
end
