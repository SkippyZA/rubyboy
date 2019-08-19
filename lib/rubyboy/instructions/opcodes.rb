module Rubyboy
  module Instructions
    module Opcodes
      class Instruction
        attr_reader :disassembly, :opperand_length, :cpu_cycles, :execute

        def initialize(disassembly, opperand_length, cpu_cycles execute)
          @disassembly = disassembly
          @opperand_length = opperand_length
          @cpu_cycles = cpu_cycles
          @execute = execute
        end
      end

      OPCODE = [
        # 0x00
        [ 'NOP', 0, 4 ],
        [ 'LD BC, 0x%04X', 2, 12 ],
        [ 'LD (BC), A', 0, 8 ],
        [ 'INC BC', 0, 8 ],
        [ 'INC B', 0, 4 ],
        [ 'DEC B', 0, 4 ],
        [ 'LD B, 0x%02X', 1, 8 ],
        [ 'RLCA', 0, 4 ],
        [ 'LD (0x%04X), SP', 2, 20 ],
        [ 'ADD HL, BC', 0, 8 ],
        [ 'LD A, (BC)', 0, 8 ],
        [ 'DEC BC', 0, 8 ],
        [ 'INC C', 0, 4 ],
        [ 'DEC C', 0, 4 ],
        [ 'LD C, 0x%02X', 1, 8 ],
        [ 'RRCA', 0, 4 ],

        # 0x10
        [ 'STOP', 1, 4 ],
        [ 'LD DE, 0x%04X', 2, 12 ],
        [ 'LD (DE), A', 0, 8 ],
        [ 'INC DE', 0, 8 ],
        [ 'INC D', 0, 4 ],
        [ 'DEC D', 0, 4 ],
        [ 'LD D, 0x%02X', 1, 8 ],
        [ 'RLA', 0, 4 ],
        [ 'JR 0x%02X', 1, 12 ],
        [ 'ADD HL, DE', 0, 8 ],
        [ 'LD A, (DE)', 0, 8 ],
        [ 'DEC DE', 0, 8 ],
        [ 'INC E', 0, 4 ],
        [ 'DEC E', 0, 4 ],
        [ 'LD E, 0x%02X', 1, 8 ],
        [ 'RRA', 0, 4 ],

        # 0x20
        [ 'JR NZ, 0x%02X', 1, 12 ],
        [ 'LD HL, 0x%04X', 2, 12 ],
        [ 'LDI (HL), A', 0, 8 ],
        [ 'INC HL', 0, 8 ],
        [ 'INC H', 0, 4 ],
        [ 'DEC H', 0, 4 ],
        [ 'LD H, 0x%02X', 1, 8 ],
        [ 'DAA', 0, 4, 4 ],
        [ 'JR Z, 0x%02X', 1, 12 ], # or cpu_cycle = 8
        [ 'ADD HL, HL', 0, 8 ],
        [ 'LDI A, (HL)', 0, 8 ],
        [ 'DEC HL', 0, 8 ],
        [ 'INC L', 0, 4 ],
        [ 'DEC L', 0, 4 ],
        [ 'LD L, 0x%02X', 1, 8 ],
        [ 'CPL', 0, 4 ],

        # 0x30
        [ 'JR NC, 0x%02X', 1, 12 ], # or cpu_cycles = 8
        [ 'LD SP, 0x%04X', 2, 12 ],
        [ 'LDD (HL), A', 0, 8 ],
        [ 'INC SP', 0, 8 ],
        [ 'INC (HL)', 0, 12 ],
        [ 'DEC (HL)', 0, 12 ],
        [ 'LD (HL), 0x%02X', 1, 12 ],
        [ 'SCF', 0, 4 ],
        [ 'JR C, 0x%02X', 1, 12 ], # or cpu_cycles = 8
        [ 'ADD HL, SP', 0, 8 ],
        [ 'LDD A, (HL)', 0, 8 ],
        [ 'DEC SP', 0, 8 ],
        [ 'INC A', 0, 4 ],
        [ 'DEC A', 0, 4 ],
        [ 'LD A, 0x%02X', 1, 8 ],
        [ 'CCF', 0, 4 ],

        # 0x40
        [ 'LD B, B', 0, 4 ],
        [ 'LD B, C', 0, 4 ],
        [ 'LD B, D', 0, 4 ],
        [ 'LD B, E', 0, 4 ],
        [ 'LD B, H', 0, 4 ],
        [ 'LD B, L', 0, 4 ],
        [ 'LD B, (HL)', 0, 8 ],
        [ 'LD B, A', 0, 4 ],
        [ 'LD C, B', 0, 4 ],
        [ 'LD C, C', 0, 4 ],
        [ 'LD C, D', 0, 4 ],
        [ 'LD C, E', 0, 4 ],
        [ 'LD C, H', 0, 4 ],
        [ 'LD C, L', 0, 4 ],
        [ 'LD C, (HL)', 0, 8 ],
        [ 'LD C, A', 0, 4 ],

        # 0x50
        [ 'LD D, B', 0, 4 ],
        [ 'LD D, C', 0, 4 ],
        [ 'LD D, D', 0, 4 ],
        [ 'LD D, E', 0, 4 ],
        [ 'LD D, H', 0, 4 ],
        [ 'LD D, L', 0, 4 ],
        [ 'LD D, (HL)', 0, 8 ],
        [ 'LD D, A', 0, 4 ],
        [ 'LD E, B', 0, 4 ],
        [ 'LD E, C', 0, 4 ],
        [ 'LD E, D', 0, 4 ],
        [ 'LD E, E', 0, 4 ],
        [ 'LD E, H', 0, 4 ],
        [ 'LD E, L', 0, 4 ],
        [ 'LD E, (HL)', 0, 8 ],
        [ 'LD E, A', 0, 4 ],

        # 0x60
        [ 'LD H, B', 0, 4 ],
        [ 'LD H, C', 0, 4 ],
        [ 'LD H, D', 0, 4 ],
        [ 'LD H, E', 0, 4 ],
        [ 'LD H, H', 0, 4 ],
        [ 'LD H, L', 0, 4 ],
        [ 'LD H, (HL)', 0, 8 ],
        [ 'LD H, A', 0, 4 ],
        [ 'LD L, B', 0, 4 ],
        [ 'LD L, C', 0, 4 ],
        [ 'LD L, D', 0, 4 ],
        [ 'LD L, E', 0, 4 ],
        [ 'LD L, H', 0, 4 ],
        [ 'LD L, L', 0, 4 ],
        [ 'LD L, (HL)', 0, 8 ],
        [ 'LD L, A', 0, 4 ],

        # 0x70
        [ 'LD (HL), B', 0, 8 ],
        [ 'LD (HL), C', 0, 8 ],
        [ 'LD (HL), D', 0, 8 ],
        [ 'LD (HL), E', 0, 8 ],
        [ 'LD (HL), H', 0, 8 ],
        [ 'LD (HL), L', 0, 8 ],
        [ 'HALT', 0, 4 ],
        [ 'LD (HL), A', 0, 8 ],
        [ 'LD A, B', 0, 4 ],
        [ 'LD A, C', 0, 4 ],
        [ 'LD A, D', 0, 4 ],
        [ 'LD A, E', 0, 4 ],
        [ 'LD A, H', 0, 4 ],
        [ 'LD A, L', 0, 4 ],
        [ 'LD A, (HL)', 0, 8 ],
        [ 'LD A, A', 0, 4 ],

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
        [ 'XOR B', 0, 4 ],
        [ 'XOR C', 0, 4 ],
        [ 'XOR D', 0, 4 ],
        [ 'XOR E', 0, 4 ],
        [ 'XOR H', 0, 4 ],
        [ 'XOR L', 0, 4 ],
        [ 'XOR (HL)', 0, 8 ],
        [ 'XOR A', 0, 4 ],

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
        [ 'RET NZ', 0, 20, 20 ], # or cpu_cycles = 8
        [ 'POP BC', 0, 12 ],
        [ 'JP NZ, 0x%04X', 2, 16 ], # or cpu_cycles = 8
        [ 'JP 0x%04X', 2, 16 ],
        [ 'CALL NZ, 0x%04X', 2, 24 ], # or cpu_cycles = 8
        [ 'PUSH BC', 0, 16 ],
        [ 'ADD A, 0x%02X', 1, 8 ],
        [ 'RST 0x00', 0, 16 ],
        [ 'RET Z', 0, 20 ], # or cpu_cycles = 8
        [ 'RET', 0, 16 ],
        [ 'JP Z, 0x%04X', 2, 16 ], # or cpu_cycles = 8
        [ 'CB %02X', 1, 4 ],
        [ 'CALL Z, 0x%04X', 2, 24 ], # or cpu_cycles = 8
        [ 'CALL 0x%04X', 2, 24 ],
        [ 'ADC 0x%02X', 1, 8 ],
        [ 'RST 0x08', 0, 16 ],

        # 0xD0
        [ 'RET NC', 0, 20 ], # or cpu_cycles = 8
        [ 'POP DE', 0, 12 ],
        [ 'JP NC, 0x%04X', 2, 16 ], # or cpu_cycles = 12
        [ 'UNKNOWN', 0, 0 ],
        [ 'CALL NC, 0x%04X', 2, 24 ], # or cpu_cycles = 12
        [ 'PUSH DE', 0, 16 ],
        [ 'SUB 0x%02X', 1, 8 ],
        [ 'RST 0x10', 0, 16 ],
        [ 'RET C', 0, 20 ], # or cpu_cycles = 8
        [ 'RETI', 0, 16 ],
        [ 'JP C, 0x%04X', 2, 16 ], # or cpu_cycles = 12
        [ 'UNKNOWN', 0, 0 ],
        [ 'CALL C, 0x%04X', 2, 24 ], # or cpu_cycles = 12
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
        [ 'JP HL', 0, 4 ],
        [ 'LD (0x%04X), A', 2, 16 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'XOR 0x%02X', 1, 8 ],
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
        [ 'LD A, (0x%04X)', 2, 16 ],
        [ 'EI', 0, 4 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'UNKNOWN', 0, 0 ],
        [ 'CP 0x%02X', 1, 8 ],
        [ 'RST 0x38', 0, 16 ]
      ].map { |o| Instruction.new o[0], o[1], o[2], o[3] }
    end
  end
end
