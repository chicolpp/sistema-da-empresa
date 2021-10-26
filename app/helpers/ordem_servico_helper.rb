#encoding: utf-8
module OrdemServicoHelper

	def bs_color_by_status(status_code)
    case status_code.to_i
    when 0
      'primary'
    when 1
      'default'
    when 2
      'success'
    when 3
      'info'
    when 4
      'warning'
    when 5
      'danger'
    else
      'success'
    end
  end
end