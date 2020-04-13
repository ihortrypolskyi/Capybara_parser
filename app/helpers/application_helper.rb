module ApplicationHelper
  def flash_class(type)
    case type
    when 'success'
      'alert alert-success'
    when 'error'
      'alert alert-danger'
    when 'alert'
      'alert alert-warning'
    when 'notice'
      'alert alert-info'
    else
      type.to_s
    end
  end
end
