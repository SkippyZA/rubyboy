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

      initialize_pointers

      @mmu = mmu
    end

    def initialize_pointers
      @af = 0x01B0
      @bc = 0x0013
      @de = 0x00D8
      @hl = 0x014D

      @sp = 0xFFFE
    end

    def step
      instruction = @mmu.read_short @pc
      operation = OPCODE[instruction]

      pc = @pc

      # Move to next location after reading the operation
      @pc += 1 & 0xFFFF

      # if operation.execute.nil?
      #   puts 'Program Counter: 0x%04X, Instruction: 0x%02X, Operation: %s' % [ pc, instruction, operation.disassembly ]
      # end

      unless operation.execute.nil?
        puts 'Program Counter: 0x%04X, Instruction: 0x%02X, Operation: %s, Implementation: :%s' % [ pc, instruction, operation.disassembly, operation.execute.to_s ]
        self.public_send operation.execute
        puts '    a=%02X, b=%02X, c=%02X, d=%02X, e=%02X, f=%02X, h=%02X, l=%02X' % [ @a, @b, @c, @d, @e, @f, @h, @l ]
        puts '    af=%04X, bc=%04X, de=%04X, hl=%04X' % [ af, bc, de, hl ]
        puts '    pc=%04X, sp=%04X' % [ @pc, @sp ]
        puts ''
      end

      # Move to next operation after reading the opcode argument
      # TODO: This will probably be best in the operation code as the logic may set a different value for the pc register
      @pc += operation.opperand_length & 0xFFFF
    end

    def nop () end
  end
end
