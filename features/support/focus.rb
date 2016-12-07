module Focus
  def focus object
    @focused_object = object
  end

  def focused_object
    raise StandardError, 'no focused object registered' unless @focused_object
    @focused_object
  end
end