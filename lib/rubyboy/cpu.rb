require "rubyboy/instructions/registers"
require "rubyboy/instructions/opcodes"
require "rubyboy/instructions/load"

module Rubyboy
  Z_FLAG = 0b1000_0000 # Zero flag
  N_FLAG = 0b0100_0000 # Add/sub flag
  H_FLAG = 0b0010_0000 # Half carry flag
  C_FLAG = 0b0001_0000 # Carry flag

  class CPU
    include Instructions::Registers
    include Instructions::Load
    include Instructions::Opcodes

    attr_reader :a, :b, :c, :d, :e, :f, :h, :l
    attr_reader :pc
    attr_reader :sp

    def initialize(mmu)
      # registers
      @a = @b = @c = @d = @e = @f = @h = @l = 0x00
      # program counter
      @pc = 0x0000
      # stack pointer
      @sp = 0x0000

      @mmu = mmu
    end
  end
end
