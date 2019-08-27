require "rubyboy/instructions/registers"
require "rubyboy/instructions/opcodes"
require "rubyboy/instructions/load"

module Rubyboy
  Z_FLAG = 0b1000_0000 # Zero flag
  N_FLAG = 0b0100_0000 # Add/sub flag
  H_FLAG = 0b0010_0000 # Half carry flag
  C_FLAG = 0b0001_0000 # Carry flag

  class CPU
    include Instructions::Opcodes
    include Instructions::Registers
    include Instructions::Load

    attr_reader :a, :b, :c, :d, :e, :f, :h, :l
    attr_reader :pc
    attr_reader :sp

    attr_reader :mmu

    def initialize(mmu)
      @mmu = mmu

      # registers
      @a = @b = @c = @d = @e = @f = @h = @l = 0x00
      # program counter
      @pc = 0x0000
      # stack pointer
      @sp = 0x0000

      initialize_registers
    end

    def initialize_registers
      @af = 0x01B0
      @bc = 0x0013
      @de = 0x00D8
      @hl = 0x014D

      @pc = 0x0100
      @sp = 0xFFFE

      @mmu.write_short 0xFF05, 0x00 # TIMA
      @mmu.write_short 0xFF06, 0x00 # TMA
      @mmu.write_short 0xFF07, 0x00 # TAC
      @mmu.write_short 0xFF10, 0x80 # NR10
      @mmu.write_short 0xFF11, 0xBF # NR11
      @mmu.write_short 0xFF12, 0xF3 # NR12
      @mmu.write_short 0xFF14, 0xBF # NR14
      @mmu.write_short 0xFF16, 0x3F # NR21
      @mmu.write_short 0xFF17, 0x00 # NR22
      @mmu.write_short 0xFF19, 0xBF # NR24
      @mmu.write_short 0xFF1A, 0x7F # NR30
      @mmu.write_short 0xFF1B, 0xFF # NR31
      @mmu.write_short 0xFF1C, 0x9F # NR32
      @mmu.write_short 0xFF1E, 0xBF # NR33
      @mmu.write_short 0xFF20, 0xFF # NR41
      @mmu.write_short 0xFF21, 0x00 # NR42
      @mmu.write_short 0xFF22, 0x00 # NR43
      @mmu.write_short 0xFF23, 0xBF # NR30
      @mmu.write_short 0xFF24, 0x77 # NR50
      @mmu.write_short 0xFF25, 0xF3 # NR51
      @mmu.write_short 0xFF26, 0xF1 # NR52
      @mmu.write_short 0xFF40, 0x91 # LCDC
      @mmu.write_short 0xFF42, 0x00 # SCY
      @mmu.write_short 0xFF43, 0x00 # SCX
      @mmu.write_short 0xFF45, 0x00 # LYC
      @mmu.write_short 0xFF47, 0xFC # BGP
      @mmu.write_short 0xFF48, 0xFF # OBP0
      @mmu.write_short 0xFF49, 0xFF # OBP1
      @mmu.write_short 0xFF4A, 0x00 # WY
      @mmu.write_short 0xFF4B, 0x00 # WX
      @mmu.write_short 0xFFFF, 0x00 # IE
    end

    def step
      instruction = @mmu.read_short @pc
      operation = OPCODE[instruction]

      pc = @pc

      # Move to next location after reading the operation
      @pc += 1 & 0xFFFF

      value = read_argument operation
      formatted_disassembly = operation.disassembly % value

      puts 'Program Counter: 0x%04X, Instruction: 0x%02X, Operation: %s' % [ pc, instruction, formatted_disassembly ] unless operation.execute.nil?

      unless operation.execute.nil?
        operation.execute.call(self)

        puts '    a=%02X, b=%02X, c=%02X, d=%02X, e=%02X, f=%02X, h=%02X, l=%02X' % [ @a, @b, @c, @d, @e, @f, @h, @l ]
        puts '    af=%04X, bc=%04X, de=%04X, hl=%04X' % [ af, bc, de, hl ]
        puts '    pc=%04X, sp=%04X' % [ @pc, @sp ]
        puts ''
      end

      # Move to next operation after reading the opcode argument
      # TODO: This will probably be best in the operation code as the logic may set a different value for the pc register
      @pc += operation.opperand_length & 0xFFFF unless [0xC3, 0xE9].include? instruction
    end

    def read_argument (operation)
      case operation.opperand_length
      when 0
        return
      when 1
        @mmu.read_short(@pc)
      when 2
        @mmu.read_word(@pc)
      end
    end

    def nop () end

    def jp (address)
      @pc = address
    end

    def jp_nn
      address = @mmu.read_word @pc
      @pc = address
    end

    def jp_hl
      @pc = hl
    end
  end
end
