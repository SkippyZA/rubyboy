module Rubyboy
  module Instructions
    module Opcodes
      class Instruction
        attr_reader :disassembly, :opperand_length, :cpu_cycles, :conditional_cpu_cycles, :execute

        def initialize(disassembly, opperand_length, cpu_cycles, execute)
          @disassembly = disassembly
          @opperand_length = opperand_length
          @execute = execute

          if cpu_cycles.is_a?(Array)
            @cpu_cycles = cpu_cycles[0]
            @conditional_cpu_cycles = cpu_cycles[1]
          else
            @cpu_cycles = cpu_cycles
            @conditional_cpu_cycles = nil
          end
        end
      end

      mark = ->(cpu) { puts "--------------------------------------------------------------------------------"; cpu }

      OPCODE = [
        # 0x00
        [ 'NOP', 0, 4, ->(cpu) { cpu.nop } ],
        [ 'LD BC, 0x%04X', 2, 12 ],
        [ 'LD (BC), A', 0, 8 ],
        [ 'INC BC', 0, 8 ],
        [ 'INC B', 0, 4 ],
        [ 'DEC B', 0, 4, ->(cpu) { cpu.dec_n :b } ],
        [ 'LD B, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :b } ],
        [ 'RLCA', 0, 4 ],
        [ 'LD (0x%04X), SP', 2, 20 ],
        [ 'ADD HL, BC', 0, 8 ],
        [ 'LD A, (BC)', 0, 8 ],
        [ 'DEC BC', 0, 8 ],
        [ 'INC C', 0, 4 ],
        [ 'DEC C', 0, 4, ->(cpu) { cpu.dec_n :c } ],
        [ 'LD C, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :c } ],
        [ 'RRCA', 0, 4 ],

        # 0x10
        [ 'STOP', 1, 4 ],
        [ 'LD DE, 0x%04X', 2, 12 ],
        [ 'LD (DE), A', 0, 8 ],
        [ 'INC DE', 0, 8 ],
        [ 'INC D', 0, 4 ],
        [ 'DEC D', 0, 4, ->(cpu) { cpu.dec_n :d } ],
        [ 'LD D, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :d } ],
        [ 'RLA', 0, 4 ],
        [ 'JR 0x%02X', 1, 12 ],
        [ 'ADD HL, DE', 0, 8 ],
        [ 'LD A, (DE)', 0, 8 ],
        [ 'DEC DE', 0, 8 ],
        [ 'INC E', 0, 4 ],
        [ 'DEC E', 0, 4, ->(cpu) { cpu.dec_n :e } ],
        [ 'LD E, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :e }],
        [ 'RRA', 0, 4 ],

        # 0x20
        [ 'JR NZ, 0x%02X', 1, 12 ],
        [ 'LD HL, 0x%04X', 2, 12, -> (cpu) { cpu.set_register :hl, cpu.mmu.read_word(cpu.pc) } ],
        [ 'LDI (HL), A', 0, 8 ],
        [ 'INC HL', 0, 8 ],
        [ 'INC H', 0, 4 ],
        [ 'DEC H', 0, 4, ->(cpu) { cpu.dec_n :h } ],
        [ 'LD H, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :h } ],
        [ 'DAA', 0, 4 ],
        [ 'JR Z, 0x%02X', 1, [ 8, 12 ] ],
        [ 'ADD HL, HL', 0, 8 ],
        [ 'LDI A, (HL)', 0, 8 ],
        [ 'DEC HL', 0, 8 ],
        [ 'INC L', 0, 4 ],
        [ 'DEC L', 0, 4, ->(cpu) { cpu.dec_n :l } ],
        [ 'LD L, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :l } ],
        [ 'CPL', 0, 4 ],

        # 0x30
        [ 'JR NC, 0x%02X', 1, [ 8, 12 ] ],
        [ 'LD SP, 0x%04X', 2, 12, -> (cpu) { cpu.set_register :sp, cpu.mmu.read_word(cpu.pc) } ],
        [ 'LDD (HL), A', 0, 8 ],
        [ 'INC SP', 0, 8 ],
        [ 'INC (HL)', 0, 12 ],
        [ 'DEC (HL)', 0, 12 ],
        [ 'LD (HL), 0x%02X', 1, 12, -> (cpu) { cpu.mmu.write_short cpu.mmu.read_word(cpu.get_register(:hl)), cpu.mmu.read_short(cpu.pc) } ],
        [ 'SCF', 0, 4 ],
        [ 'JR C, 0x%02X', 1, [ 8, 12 ] ],
        [ 'ADD HL, SP', 0, 8 ],
        [ 'LDD A, (HL)', 0, 8 ],
        [ 'DEC SP', 0, 8 ],
        [ 'INC A', 0, 4 ],
        [ 'DEC A', 0, 4, ->(cpu) { cpu.dec_n :a } ],
        [ 'LD A, 0x%02X', 1, 8, ->(cpu) { cpu.load_nn_n :a } ],
        [ 'CCF', 0, 4 ],

        # 0x40
        [ 'LD B, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :b } ],
        [ 'LD B, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :c } ],
        [ 'LD B, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :d } ],
        [ 'LD B, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :e } ],
        [ 'LD B, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :h } ],
        [ 'LD B, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :l } ],
        [ 'LD B, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :b } ],
        [ 'LD B, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :b, :a } ], #
        [ 'LD C, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :b } ],
        [ 'LD C, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :c } ],
        [ 'LD C, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :d } ],
        [ 'LD C, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :e } ],
        [ 'LD C, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :h } ],
        [ 'LD C, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :l } ],
        [ 'LD C, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :c } ],
        [ 'LD C, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :c, :a } ], #

        # 0x50
        [ 'LD D, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :b } ],
        [ 'LD D, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :c } ],
        [ 'LD D, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :d } ],
        [ 'LD D, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :e } ],
        [ 'LD D, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :h } ],
        [ 'LD D, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :l } ],
        [ 'LD D, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :d } ],
        [ 'LD D, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :d, :a } ], #
        [ 'LD E, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :b } ],
        [ 'LD E, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :c } ],
        [ 'LD E, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :d } ],
        [ 'LD E, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :e } ],
        [ 'LD E, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :h } ],
        [ 'LD E, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :l } ],
        [ 'LD E, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :e } ],
        [ 'LD E, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :e, :a } ], #

        # 0x60
        [ 'LD H, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :b } ],
        [ 'LD H, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :c } ],
        [ 'LD H, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :d } ],
        [ 'LD H, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :e } ],
        [ 'LD H, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :h } ],
        [ 'LD H, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :l } ],
        [ 'LD H, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :h } ],
        [ 'LD H, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :h, :a } ], #

        [ 'LD L, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :b } ],
        [ 'LD L, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :c } ],
        [ 'LD L, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :d } ],
        [ 'LD L, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :e } ],
        [ 'LD L, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :h } ],
        [ 'LD L, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :l } ],
        [ 'LD L, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :l } ],
        [ 'LD L, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :l, :a } ], #

        # 0x70
        [ 'LD (HL), B', 0, 8, ->(cpu) { cpu.load_hl_n :b } ],
        [ 'LD (HL), C', 0, 8, ->(cpu) { cpu.load_hl_n :c } ],
        [ 'LD (HL), D', 0, 8, ->(cpu) { cpu.load_hl_n :d } ],
        [ 'LD (HL), E', 0, 8, ->(cpu) { cpu.load_hl_n :e } ],
        [ 'LD (HL), H', 0, 8, ->(cpu) { cpu.load_hl_n :h } ],
        [ 'LD (HL), L', 0, 8, ->(cpu) { cpu.load_hl_n :l } ],
        [ 'HALT', 0, 4 ],
        [ 'LD (HL), A', 0, 8, ->(cpu) { cpu.load_hl_n :a } ],
        [ 'LD A, B', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :b } ],
        [ 'LD A, C', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :c } ],
        [ 'LD A, D', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :d } ],
        [ 'LD A, E', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :e } ],
        [ 'LD A, H', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :h } ],
        [ 'LD A, L', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :l } ],
        [ 'LD A, (HL)', 0, 8, ->(cpu) { cpu.load_n_hl :a } ],
        [ 'LD A, A', 0, 4, ->(cpu) { cpu.load_r1_r2 :a, :a } ],

        # 0x80
        [ 'ADD A, B', 0, 4 ],
        [ 'ADD A, C', 0, 4 ],
        [ 'ADD A, D', 0, 4 ],
        [ 'ADD A, E', 0, 4 ],
        [ 'ADD A, H', 0, 4 ],
        [ 'ADD A, L', 0, 4 ],
        [ 'ADD A, (HL)', 0, 8 ],
        [ 'ADD A', 0, 4 ],
        [ 'ADC B', 0, 4 ],
        [ 'ADC C', 0, 4 ],
        [ 'ADC D', 0, 4 ],
        [ 'ADC E', 0, 4 ],
        [ 'ADC H', 0, 4 ],
        [ 'ADC L', 0, 4 ],
        [ 'ADC (HL)', 0, 8 ],
        [ 'ADC A', 0, 4 ],

        # 0x90
        [ 'SUB B', 0, 4 ],
        [ 'SUB C', 0, 4 ],
        [ 'SUB D', 0, 4 ],
        [ 'SUB E', 0, 4 ],
        [ 'SUB H', 0, 4 ],
        [ 'SUB L', 0, 4 ],
        [ 'SUB (HL)', 0, 8 ],
        [ 'SUB A', 0, 4 ],
        [ 'SBC B', 0, 4 ],
        [ 'SBC C', 0, 4 ],
        [ 'SBC D', 0, 4 ],
        [ 'SBC E', 0, 4 ],
        [ 'SBC H', 0, 4 ],
        [ 'SBC L', 0, 4 ],
        [ 'SBC (HL)', 0, 8 ],
        [ 'SBC A', 0, 4 ],

        # 0xA0
        [ 'AND B', 0, 4 ],
        [ 'AND C', 0, 4 ],
        [ 'AND D', 0, 4 ],
        [ 'AND E', 0, 4 ],
        [ 'AND H', 0, 4 ],
        [ 'AND L', 0, 4 ],
        [ 'AND (HL)', 0, 8 ],
        [ 'AND A', 0, 4 ],
        [ 'XOR B', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:b) } ],
        [ 'XOR C', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:c) } ],
        [ 'XOR D', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:d) } ],
        [ 'XOR E', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:e) } ],
        [ 'XOR H', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:h) } ],
        [ 'XOR L', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:l) } ],
        [ 'XOR (HL)', 0, 8, ->(cpu) { cpu.xor cpu.get_register(cpu.mmu.read_word(cpu.get_register(:hl))) } ],
        [ 'XOR A', 0, 4, ->(cpu) { cpu.xor cpu.get_register(:a) } ],

        # 0xB0
        [ 'OR B', 0, 4 ],
        [ 'OR C', 0, 4 ],
        [ 'OR D', 0, 4 ],
        [ 'OR E', 0, 4 ],
        [ 'OR H', 0, 4 ],
        [ 'OR L', 0, 4 ],
        [ 'OR (HL)', 0, 8 ],
        [ 'OR A', 0, 4 ],
        [ 'CP B', 0, 4 ],
        [ 'CP C', 0, 4 ],
        [ 'CP D', 0, 4 ],
        [ 'CP E', 0, 4 ],
        [ 'CP H', 0, 4 ],
        [ 'CP L', 0, 4 ],
        [ 'CP (HL)', 0, 8 ],
        [ 'CP A', 0, 4 ],

        # 0xC0
        [ 'RET NZ', 0, [ 8, 20 ] ],
        [ 'POP BC', 0, 12 ],
        [ 'JP NZ, 0x%04X', 2, [ 8, 16 ], ->(cpu) { cpu.jpnc Z_FLAG, cpu.mmu.read_word(cpu.pc) }],
        [ 'JP 0x%04X', 2, 16, ->(cpu) { cpu.jp cpu.mmu.read_word(cpu.pc) } ],
        [ 'CALL NZ, 0x%04X', 2, [ 8, 24 ] ],
        [ 'PUSH BC', 0, 16 ],
        [ 'ADD A, 0x%02X', 1, 8 ],
        [ 'RST 0x00', 0, 16 ],
        [ 'RET Z', 0, [ 8, 20 ] ],
        [ 'RET', 0, 16 ],
        [ 'JP Z, 0x%04X', 2, [ 8, 16 ], ->(cpu) { cpu.jpc(Z_FLAG, cpu.mmu.read_word(cpu.pc)) } ],
        [ 'CB %02X', 1, 4 ],
        [ 'CALL Z, 0x%04X', 2, [ 8, 24 ] ],
        [ 'CALL 0x%04X', 2, 24 ],
        [ 'ADC 0x%02X', 1, 8 ],
        [ 'RST 0x08', 0, 16 ],

        # 0xD0
        [ 'RET NC', 0, [ 8, 20 ] ],
        [ 'POP DE', 0, 12 ],
        [ 'JP NC, 0x%04X', 2, [ 12, 16 ], ->(cpu) { cpu.jpnc(C_FLAG, cpu.mmu.read_word(cpu.pc)) } ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'CALL NC, 0x%04X', 2, [ 12, 24 ] ],
        [ 'PUSH DE', 0, 16 ],
        [ 'SUB 0x%02X', 1, 8 ],
        [ 'RST 0x10', 0, 16 ],
        [ 'RET C', 0, [ 20, 8 ] ],
        [ 'RETI', 0, 16 ],
        [ 'JP C, 0x%04X', 2, [ 12, 16 ], ->(cpu) { cpu.jpc(C_FLAG, cpu.mmu.read_word(cpu.pc)) } ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'CALL C, 0x%04X', 2, [ 12, 24 ] ],
        [ 'UNKNOWN', 0 ],
        [ 'SBC 0x%02X', 1, 8 ],
        [ 'RST 0x18', 0, 16 ],

        # 0xE0
        [ 'LD (0xFF00 + 0x%02X), A', 1, 12 ],
        [ 'POP HL', 0, 12 ],
        [ 'LD (0xFF00 + C), A', 0, 8 ],
        [ 'UNKNOWN', 0 ],
        [ 'UNKNOWN', 0 ],
        [ 'PUSH HL', 0, 16 ],
        [ 'AND 0x%02X', 1, 8 ],
        [ 'RST 0x20', 0, 16 ],
        [ 'ADD SP,0x%02X', 1, 16 ],
        [ 'JP HL', 0, 4, ->(cpu) { cpu.jp :hl }] ,
        [ 'LD (0x%04X), A', 2, 16, ->(cpu) { cpu.mmu.write_short(cpu.mmu.read_word(cpu.pc), cpu.get_register(:a)) } ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'XOR 0x%02X', 1, 8, ->(cpu) { cpu.xor cpu.mmu.read_short(cpu.pc) } ],
        [ 'RST 0x28', 0, 16 ],

        # 0xF0
        [ 'LD A, (0xFF00 + 0x%02X)', 1, 12 ],
        [ 'POP AF', 0, 12 ],
        [ 'LD A, (0xFF00 + C)', 0, 8 ],
        [ 'DI', 0, 4 ],
        [ 'UNKNOWN', 0, 16 ],
        [ 'PUSH AF', 0, 8 ],
        [ 'OR 0x%02X', 1, 8 ],
        [ 'RST 0x30', 0, 16 ],
        [ 'LD HL, SP+0x%02X', 1, 12 ],
        [ 'LD SP, HL', 0, 8 ],
        [ 'LD A, (0x%04X)', 2, 16, ->(cpu) { cpu.set_register :a, cpu.mmu.read_byte(cpu.mmu.read_word(pc)) } ],
        [ 'EI', 0, 4 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'CP 0x%02X', 1, 8 ],
        [ 'RST 0x38', 0, 16 ]
      ].map { |o| Instruction.new o[0], o[1], o[2], o[3] }.freeze
    end
  end
end
