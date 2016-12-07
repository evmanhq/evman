module Authorization
  def self.activate(user, team)
    Thread.current[:dictator] = Dictator.new(user, team)
    dictator.activate
  end

  def self.deactivate
    dictator.deactivate
  end

  def self.dictator
    Thread.current[:dictator] ||= Dictator.new(nil, nil)
  end

  def self.can_do_anything!
    dictator.deactivate
    yield
    dictator.activate
  end
end