class RecentQueue
  attr_accessor :max_length

  def self.current_queue
    Thread.current[:queue] 
  end

  def self.current_queue=(queue)
    Thread.current[:queue] = queue
  end

  def self.find
    new(current_queue)
  end
  
  def initialize(queue = Array.new, max_length = 8)
    @queue = queue
    @max_length = max_length
    resize_queue
  end

  def push(element)
    unless @queue.first == element
      @queue.unshift(element)
      resize_queue
    end
  end

  alias :<< :push

  def to_a
    @queue.dup
  end

  def method_missing(method, *params, &block)
    @queue.send(method, *params, &block)
  end

  private

  def resize_queue
    @queue.slice!(@max_length, @queue.length - @max_length) if @queue.length > @max_length
  end
end
