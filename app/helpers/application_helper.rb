module ApplicationHelper

  def current_user
    @current_user
  end

  def current_team
    @current_team
  end

  def markdown(content)
    return nil unless content
    raw Kramdown::Document.new(content).to_html
  end

  def icon(type, source=:bootstrap)
    case source
    when :bs, :bootstrap
      content_tag "i", nil, class: "gliphicon gliphicon-#{type}"
    when :fa, :fontawesome
      content_tag "i", nil, class: "fa fa-#{type}"
    else
      "INVALID ICON SOURCE"
    end
  end

  def boolean_icon(value)
    if value
      icon('check-circle', :fa)
    else
      icon('times-circle', :fa)
    end
  end

  def validation_errors record
    return unless record.errors.any?
    render partial: 'application/validation_errors', locals: { record: record }
  end

  def record_errors record
    return unless record.errors.any?
    render partial: 'application/record_errors', locals: { record: record }
  end
end
