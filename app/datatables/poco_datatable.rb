class PocoDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :casein_poco_path
  def_delegator :@view, :edit_casein_poco_path
  def_delegator :@view, :casein_show_row_icon

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Poco.id" },
      nome: { source: "Pessoa.nome", cond: :like, searchable: true, orderable: true },
      linha_endereco: { source: "Poco.linha_endereco", cond: :like, searchable: true, orderable: true },
      apelido_endereco: { source: "Poco.apelido_endereco", cond: :like, searchable: true, orderable: true },
      cidade: { source: "Cidade.nome", cond: :like, searchable: true, orderable: true },
      produtivo: { source: "Poco.poco_produtivo", cond: :like, searchable: false, orderable: true },
      perfuracao_leao: { source: "Poco.perfuracao_leao", cond: :like, searchable: false, orderable: true },
      view: { searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        nome: record.nome_poco,
        linha_endereco: record.linha_endereco,
        apelido_endereco: record.apelido_endereco,
        cidade: record.cidade.try(:get_nome_completo),
        produtivo: record.poco_produtivo ? "Sim" : "Não",
        perfuracao_leao: record.perfuracao_leao ? "Sim" : "Não",
        view: (link_to(casein_show_row_icon("zoom-in"), casein_poco_path(record), class: "icon-table") + link_to(casein_show_row_icon("edit"), edit_casein_poco_path(record), class: "icon-table") + link_to(casein_show_row_icon("trash"), casein_poco_path(record), class: "icon-table", method: :delete, data: { confirm: "Você tem certeza que deseja apagar este registro?" })).html_safe,
      }
    end
  end

  private

  def get_raw_records
    Poco.joins(cliente: [:pessoa]).joins(:cidade)
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
