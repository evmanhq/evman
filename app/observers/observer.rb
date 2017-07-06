class Observer

  CALLBACKS = [
      :before_validation,
      :after_validation,
      :before_save,
      :after_save,
      :before_create,
      :after_create,
      :before_update,
      :after_update,
      :before_destroy,
      :after_destroy,
      :after_commit,
      :after_rollback,
  ] unless const_defined?('CALLBACKS')

  OBSERVERS = {} unless const_defined?('OBSERVERS')

  class << self

    def setup_observers
      Rails.logger.info('Enabling observation')
      path = File.join(Rails.root, 'app', 'observers')
      Dir.glob(File.join(path, '*.rb')) do |file|
        require file
      end
    end

    def observe(clazz, events=nil, observer=self)
      instrument_for_observation(clazz)
      OBSERVERS[clazz] ||= {}
      events = CALLBACKS unless events
      events.each do |event|
        (OBSERVERS[clazz][event] ||= []) << observer
      end
    end

    def instrument_for_observation(clazz)
      return if clazz.instance_variable_defined?('@instrumented_for_observation')
      Rails.logger.info("Instrumenting #{clazz} for observation")
      CALLBACKS.each do |callback|
        clazz.send(callback) do
          Observer.trigger_event(clazz, callback, self)
        end
      end
      clazz.instance_variable_set('@instrumented_for_observation', true)
    end

    def trigger_event(clazz, callback, instance)
      per_class = OBSERVERS[clazz] || {}
      per_event = per_class[callback] || []
      per_event.each do |clazz|
        observer = clazz.new
        observer.send(callback, instance) if observer.respond_to?(callback)
      end
    end

  end

end