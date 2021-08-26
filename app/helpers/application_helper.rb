#encoding: utf-8
module ApplicationHelper

	def link_to_add_fields(name, f, association, cssClass, title, target)
	  new_object = f.object.class.reflect_on_association(association).klass.new
	  fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
	    render("casein/" + association.to_s + "/form", :f => builder)
	  end
	  link_to name, "#", :onclick => h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{target}\")"), class: cssClass, title: title, remote: true
	end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0);", :onclick => "remove_fields(this)")
  end

  def link_to_add_fields_v2(name=nil, f=nil, association=nil, options=nil, &block)
    name, f, association, options = block, name, f, association if block_given?
    options ||= {}
    options[:class] = options[:class] ? options[:class]+" add_fields-v2" : "add_fields-v2"
    options[:data] ||= {}
    local_partial = options.delete(:local_partial)
    params_partial = options.delete(:params_partial) || {}
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id.to_s) do |builder|
      if local_partial
        render(local_partial, {f: builder}.merge(params_partial))
      else
        render(association.to_s.singularize + "_fields", {f: builder}.merge(params_partial))
      end
    end
    options[:data].merge!({id: id, fields: fields.gsub("\n", "")})
    content_tag(:a, name, options.merge(href: 'javascript:;'), &block)
  end

  def get_idade(data_nascimento)
    now = Time.now.utc.to_date
    now.year - data_nascimento.year - ((now.month > data_nascimento.month || (now.month == data_nascimento.month && now.day >= data_nascimento.day)) ? 0 : 1)
  end

  def get_perfuracao_pergunta1(tipo)
    case tipo
    when 0
      return "Internet"
    when 1
      return "Rádio"
    when 2
      return "Jornais"
    when 3
      return "TV"
    when 4
      return "Outdoors"
    when 5
      return "Indicação"
    when 10
      return "Outros"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta2(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta3(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta4(tipo)
    case tipo
    when 1
      return "Muito Ruim"
    when 2
      return "Ruim"
    when 3
      return "Regular"
    when 4
      return "Bom"
    when 5
      return "Ótimo"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta5(tipo)
    case tipo
    when 1
      return "Muito Ruim"
    when 2
      return "Ruim"
    when 3
      return "Regular"
    when 4
      return "Bom"
    when 5
      return "Ótimo"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta6(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta7(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_perfuracao_pergunta8(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta1(tipo)
    case tipo
    when 0
      return "Internet"
    when 1
      return "Rádio"
    when 2
      return "Jornais"
    when 3
      return "TV"
    when 4
      return "Outdoors"
    when 5
      return "Indicação"
    when 6
      return "Avisos nos quadros"
    when 10
      return "Outros"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta2(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta3(tipo)
    case tipo
    when 1
      return "1"
    when 2
      return "2"
    when 3
      return "3"
    when 4
      return "4"
    when 5
      return "5"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta4(tipo)
    case tipo
    when 1
      return "1"
    when 2
      return "2"
    when 3
      return "3"
    when 4
      return "4"
    when 5
      return "5"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta5(tipo)
    case tipo
    when 1
      return "Muito Ruim"
    when 2
      return "Ruim"
    when 3
      return "Regular"
    when 4
      return "Bom"
    when 5
      return "Ótimo"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta6(tipo)
    case tipo
    when 1
      return "Muito Ruim"
    when 2
      return "Ruim"
    when 3
      return "Regular"
    when 4
      return "Bom"
    when 5
      return "Ótimo"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta7(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta8(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_assistencia_pergunta9(tipo)
    case tipo
    when 0
      return "Sim"
    when 1
      return "Não"
    else
      return "-"
    end
  end

  def get_tipo_endereco(tipo)
    case tipo
    when 0
      return "Residencial"
    when 1
      return "Comercial"
    when 2
      return "Caixa Postal"
    else
      return "-"
    end
  end

  def get_acesso_poco(acesso)
    case acesso
    when 0
      return "Ótimo"
    when 1
      return "Bom"
    when 2
      return "Satisfatório"
    when 3
      return "Ruim"
    when 4
      return "Péssimo"
    end
  end

  def get_tipo_manutencao_servico(tipo)
    case tipo
    when 0
      return "Início"
    when 1
      return "Conserto/Revisão"
    when 2
      return "Finalização"
    else
      return "-"
    end
  end

  def montar_link(type_notification, poco_id)
    case type_notification
    when "notification_manutencao"
      "/casein/pocos/filtrar/relatorio_detalhes?id=#{poco_id}"
    end
  end

  def montar_title(type_notification, poco_id)
    poco = Poco.find poco_id
    case type_notification
    when "notification_manutencao"
      "Manutenção - " + poco.nome_intuitivo.to_s
    end
  end
end