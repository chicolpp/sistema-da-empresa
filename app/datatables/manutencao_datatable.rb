class ManutencaoDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :l
  def_delegator :@view, :link_to
  def_delegator :@view, :current_user
  def_delegator :@view, :get_tipo_manutencao_servico
  def_delegator :@view, :casein_manutencao_path
  def_delegator :@view, :edit_casein_manutencao_path
  def_delegator :@view, :casein_show_row_icon

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Manutencao.id" },
      nome: { source: "Pessoa.nome", cond: :like, searchable: true, orderable: true },
      linha_endereco: { source: "Poco.linha_endereco", cond: :like, searchable: true, orderable: true },
      apelido_endereco: { source: "Poco.apelido_endereco", cond: :like, searchable: true, orderable: true },
      tipo: { source: "Servico.descricao", cond: :like, searchable: true, orderable: true },
      ultimo_servico: { source: "ManutencaoServico.descricao", cond: :like, searchable: true, orderable: true },
      data: { source: "ManutencaoServico.data_servico", cond: :like, searchable: true, orderable: true },
      view: { searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        nome: record.poco.nome_poco,
        linha_endereco: record.poco.linha_endereco,
        apelido_endereco: record.poco.apelido_endereco,
        tipo: record.servico.descricao,
        ultimo_servico: record.manutencao_servicos.last.try(:tipo).blank? ? "" : get_tipo_manutencao_servico(record.manutencao_servicos.last.try(:tipo)).to_s + ": " + record.manutencao_servicos.last.try(:descricao).to_s.truncate(50),
        data: record.manutencao_servicos.last.try(:data_servico).blank? ? "" : l(record.manutencao_servicos.last.try(:data_servico)),
        view: (link_to(casein_show_row_icon("zoom-in"), casein_manutencao_path(record), class: "icon-table") + link_to(casein_show_row_icon("edit"), edit_casein_manutencao_path(record), class: "icon-table") + link_to(casein_show_row_icon("trash"), casein_manutencao_path(record), class: "icon-table", method: :delete, data: { confirm: "Você tem certeza que deseja apagar este registro?" })).html_safe,
      }
    end
  end

  private

  def get_raw_records
    if current_user.is_admin?
      Manutencao.joins(poco: [cliente: [:pessoa]]).joins(:manutencao_servicos).joins(:servico).joins("LEFT JOIN ordem_servicos on ordem_servicos.id = manutencaos.ordem_servico_id").where('ordem_servico_id is null or ordem_servicos.status = 5')
    else
      Manutencao.joins(poco: [cliente: [:pessoa]]).joins(:manutencao_servicos).joins(:servico).joins("LEFT JOIN ordem_servicos on ordem_servicos.id = manutencaos.ordem_servico_id").where("pocos.cidade_id IN (SELECT usuario_cidades.cidade_id FROM usuario_cidades WHERE usuario_cidades.admin_user_id = #{current_user.id})").where('ordem_servico_id is null or ordem_servicos.status = 5')
    end
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
