# frozen_string_literal: true

require_relative './memman/byte.rb'
require_relative './memman/block.rb'

module MemMan
  class MemManError < StandardError; end
  class IllegalAccessError < MemManError; end
  class MemoryOverrunError < MemManError; end
  class OutOfMemoryError < MemManError; end

  def self.reserve_block(block_size)
    Block.new(block_size)
  end
end
