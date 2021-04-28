class AprofundamentoDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :l
  def_delegator :@view, :link_to
  def_delegator :@view, :casein_aprofundamento_path
  def_delegator :@view, :edit_casein_aprofundamento_path
  def_delegator :@view, :casein_show_row_icon

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Aprofundamento.id" },
      nome: { source: "Pessoa.nome", cond: :like, searchable: true, orderable: true },
      linha_endereco: { source: "Poco.linha_endereco", cond: :like, searchable: true, orderable: true },
      apelido_endereco: { source: "Poco.apelido_endereco", cond: :like, searchable: true, orderable: true },
      cidade: { source: "Cidade.nome", cond: :like, searchable: true, orderable: true },
      data_inicio: { source: "Aprofundamento.data_inicio", cond: :like, searchable: true, orderable: true },
      data_fim: { source: "Aprofundamento.data_fim", cond: :like, searchable: true, orderable: true },
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
        cidade: record.poco.cidade.try(:get_nome_completo),
        data_inicio: record.data_inicio.blank? ? "" : l(record.data_inicio),
        data_fim: record.data_fim.blank? ? "" : l(record.data_fim),
        view: (link_to(casein_show_row_icon("zoom-in"), casein_aprofundamento_path(record), class: "icon-table") + link_to(casein_show_row_icon("edit"), edit_casein_aprofundamento_path(record), class: "icon-table") + link_to(casein_show_row_icon("trash"), casein_aprofundamento_path(record), class: "icon-table", method: :delete, data: { confirm: "Você tem certeza que deseja apagar este registro?" })).html_safe,
      }
    end
  end

  private

  def get_raw_records
    Aprofundamento.joins(poco:[:cidade, cliente: [:pessoa]])
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
