module Observation
  def observe_object object
    @observed_object = object
  end

  def observable
    raise StandardError, 'no observable registered' unless @observed_object
    @observed_object
  end

  def observable_content
    case @observed_object
    when Event
      observable_content_event @observed_object
    end
  end

  private

  def observable_content_event object
    object.name
  end
end