class ClienteDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :casein_pessoa_path
  def_delegator :@view, :edit_casein_pessoa_path
  def_delegator :@view, :casein_show_row_icon

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Cliente.id" },
      nome: { source: "Pessoa.nome", cond: :like, searchable: true, orderable: true },
      tipo: { source: "Pessoa.tipo", cond: :like, searchable: true, orderable: true },
      email_contato: { source: "Pessoa.email_contato", cond: :like, searchable: true, orderable: true },
      view: { searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        nome: record.nome,
        tipo: record.tipo ? record.pessoa_juridica ? record.pessoa_juridica.cnpj : "-" : record.pessoa_fisica ? record.pessoa_fisica.cpf : "-",
        email_contato: record.email_contato,
        view: (link_to(casein_show_row_icon("zoom-in"), casein_pessoa_path(record), class: "icon-table") + link_to(casein_show_row_icon("edit"), edit_casein_pessoa_path(record), class: "icon-table") + link_to(casein_show_row_icon("trash"), casein_pessoa_path(record), class: "icon-table", method: :delete, data: { confirm: "Você tem certeza que deseja apagar este registro?" })).html_safe,
      }
    end
  end

  private

  def get_raw_records
    Pessoa.joins(:cliente)
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
