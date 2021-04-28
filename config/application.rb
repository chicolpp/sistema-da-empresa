require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sistema
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'globals.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.time_zone = "Brasilia"
    config.active_record.default_timezone = :local
    config.encoding = "utf-8"

    config.i18n.locale = 'pt-BR-orcamentos'
    config.i18n.locale = 'pt-BR-pos_vendas'
    config.i18n.locale = 'pt-BR-servicos'
    config.i18n.locale = 'pt-BR-aprofundamentos'
    config.i18n.locale = 'pt-BR-produtos'
    config.i18n.locale = 'pt-BR-unidades_medidas'
    config.i18n.locale = 'pt-BR-marcas'
    config.i18n.locale = 'pt-BR-instalacoes'
    config.i18n.locale = 'pt-BR-vazoes_agua'
    config.i18n.locale = 'pt-BR-cargos'
    config.i18n.locale = 'pt-BR-tipo_revestimentos'
    config.i18n.locale = 'pt-BR-pocos'
    config.i18n.locale = 'pt-BR-bitolas'
    config.i18n.locale = 'pt-BR-maquinas'
    config.i18n.locale = 'pt-BR-perfuracoes'
    config.i18n.locale = 'pt-BR-motores'
    config.i18n.locale = 'pt-BR-modelo_bombas'
    config.i18n.locale = 'pt-BR-hps'
    config.i18n.locale = 'pt-BR-estagios'
    config.i18n.locale = 'pt-BR-bombeadores'
    config.i18n.locale = 'pt-BR-energias'
    config.i18n.locale = 'pt-BR-bombas'
    config.i18n.locale = 'pt-BR-fornecedores'
    config.i18n.locale = 'pt-BR-funcionarios'
    config.i18n.locale = 'pt-BR-clientes'
    config.i18n.locale = 'pt-BR-pessoas'
    config.i18n.locale = 'pt-BR'
    config.i18n.default_locale = 'pt-BR'
  end
end

module Api
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
  end
end
