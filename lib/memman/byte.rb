# frozen_string_literal: true

module MemMan
  class Byte
    attr_accessor :value
    attr_accessor :parent

    def initialize(parent, value = nil)
      @parent = parent
      @value = value
    end
  end
end

