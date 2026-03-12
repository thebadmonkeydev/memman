# frozen_string_literal: true

module MemMan
  class Block
    attr_accessor :size
    attr_accessor :bytes

    def initialize(size)
      # Initialize array of "bytes" and set their values to nil
      @bytes = Array.new(size, nil)
      @size = size
    end

    def write(data)
      check_freed!

      raise MemoryOverrunError if data.length > size

      data.to_s.chars.each_with_index do |d, i|
        @bytes[i] = Byte.new(d)
      end
    end

    def read
      check_freed!

      bytes.map { |b| b ? b.value : nil }
    end

    def free
      @freed = true
    end

    def alloc(sub_size)
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
