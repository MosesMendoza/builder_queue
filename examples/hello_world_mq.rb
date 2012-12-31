require 'rubygems'
require 'amqp'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP connection on #{AMQP::VERSION}"

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue("amqpgem.examples.helloworld", :auto_delete => true)
  exchange = channel.direct("")

  queue.subscribe do |payload|
    puts "Recieved message: #{payload}"
    connection.close do
      EventMachine.stop
    end
  end

  exchange.publish "Hello world!", :routing_key => queue.name
end

