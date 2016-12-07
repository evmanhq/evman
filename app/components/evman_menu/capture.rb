module EvmanMenu
  class Capture
    attr_reader :data

    def initialize data
      @data = data
    end

    def captures? request
      case data
        when String
          request.path == data
        when Hash
          capture_params = ActionController::Parameters.new(data)
          request_params = ActionController::Parameters.new(request.params.slice(*capture_params.keys))
          hash_equals?(request_params, capture_params)
      end
    end

    def hash_equals? h1, h2
      h1.each do |k, v|
        h1[k] = v.to_s
      end

      h2.each do |k, v|
        h2[k] = v.to_s
      end

      h1 == h2
    end
  end
end