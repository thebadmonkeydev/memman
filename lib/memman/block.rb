# frozen_string_literal: true

require_relative './byte.rb'

module MemMan
  class Block
    attr_accessor :size
    attr_accessor :bytes
    attr_accessor :parent

    def initialize(size, parent = nil, byte_array = nil)
      if byte_array
        @bytes = byte_array
      else
        # Initialize array of "bytes" and set their values to nil
        @bytes = Array.new(size, nil)
      end

      @size = size
    end

    def write(data)
      check_freed!

      raise MemoryOverrunError if data.length > size

      case data
      when String
        data.chars.each_with_index do |c, i|
          @bytes[i] = Byte.new(self, c)
        end
      when Array
        data.each_with_index do |d, i|
          @bytes[i] = Byte.new(self, d)
        end
      else
        raise IllegalAccessError
      end
    end

    def read
      check_freed!

      bytes.map { |b| b ? b.value : nil }
    end

    def set_free
      @freed = true
    end

    def free(mem_block = self)
      mem_block.set_free
    end

    def unallocated_space
      bytes.count { |b| b == nil }
    end

    def alloc(sub_size)
      raise OutOfMemoryError if sub_size > unallocated_space

      sub_array = []
      sub_size.times do
        first_free = bytes.find_index { |b| b.nil? }
        @bytes[first_free] = Byte.new(self)
        sub_array << bytes[first_free]
      end

      Block.new(sub_size, sub_array)
    end

    protected

    def check_freed!
      raise IllegalAccessError.new if check_freed
    end

    def check_freed
      !!@freed
    end
  end
end
