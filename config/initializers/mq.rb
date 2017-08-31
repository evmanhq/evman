class MessageQueue

  class << self
    attr_accessor :provider
  end

  def publish(message, topic)
    raise Exception.new('Publishing is not implemented')
  end

  def receive
    raise Exception.new('Receiving is not implemented')
  end

end

class KafkaMessageQueue < MessageQueue
  def initialize(brokers)
    @brokers = brokers.split(',')
    @kafka = Kafka.new(seed_brokers: @brokers, client_id: 'evman')
  end

  def publish(message, topic)
    unless message.kind_of?(String)
      message = MultiJson.dump(message)
    end
    @kafka.deliver_message(message, topic: topic)
  end
end

if ENV['KAFKA_BROKERS']
  require 'kafka'
  MessageQueue.provider = KafkaMessageQueue.new(ENV['KAFKA_BROKERS'])
end