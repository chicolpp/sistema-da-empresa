class VazaoAguaDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :casein_vazao_agua_path
  def_delegator :@view, :edit_casein_vazao_agua_path
  def_delegator :@view, :casein_show_row_icon

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "VazaoAgua.id" },
      nome: { source: "Pessoa.nome", cond: :like, searchable: true, orderable: true },
      linha_endereco: { source: "Poco.linha_endereco", cond: :like, searchable: true, orderable: true },
      apelido_endereco: { source: "Poco.apelido_endereco", cond: :like, searchable: true, orderable: true },
      vazao_teste: { source: "VazaoAgua.vazao_teste", cond: :like, searchable: true, orderable: true },
      vazao_dinamico: { source: "VazaoAgua.vazao_dinamico", cond: :like, searchable: true, orderable: true },
      nivel_estatico: { source: "VazaoAgua.nivel_estatico", cond: :like, searchable: true, orderable: true },
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
        vazao_teste: record.vazao_teste,
        vazao_dinamico: record.vazao_dinamico,
        nivel_estatico: record.nivel_estatico,
        view: (link_to(casein_show_row_icon("zoom-in"), casein_vazao_agua_path(record), class: "icon-table") + link_to(casein_show_row_icon("edit"), edit_casein_vazao_agua_path(record), class: "icon-table") + link_to(casein_show_row_icon("trash"), casein_vazao_agua_path(record), class: "icon-table", method: :delete, data: { confirm: "Você tem certeza que deseja apagar este registro?" })).html_safe,
      }
    end
  end

  private

  def get_raw_records
    VazaoAgua.joins(poco: [cliente: [:pessoa]])
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
