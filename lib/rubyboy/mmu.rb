module Rubyboy
  class MMU
    # 0000 – 3FFF [ ROM0   ] Non-switchable ROM Bank.
    # 4000 – 7FFF [ ROMX   ] Switchable ROM bank.
    # 8000 – 9FFF [ VRAM   ] Video RAM, switchable (0-1) in GBC mode.
    # A000 – BFFF [ SRAM   ] External RAM in cartridge, often battery buffered.
    # C000 – CFFF [ WRAM0  ] Work RAM.
    # D000 – DFFF [ WRAMX  ] Work RAM, switchable (1-7) in GBC mode
    # E000 – FDFF [ ECHO   ]
    # FE00 – FE9F [ OAM    ] (Object Attribute Table) Sprite information table.
    # FEA0 – FEFF [ UNUSED ]
    # FF00 – FF7F [ I/O    ] Registers I/O registers are mapped here.
    # FF80 – FFFE [ HRAM   ] Internal CPU RAM
    # FFFF        [ IE     ] Register Interrupt enable flags.
    MEMORY_SIZE = 65536 # bytes

    def initialize(cartridge)
      @cartridge = cartridge
      # zero fill memory
      @memory = Array.new MEMORY_SIZE, 0
    end

    def [](address)
      @memory[address]
    end

    def []=(address, value)
      @memory[address] = value
    end

    def read_short(address)
      self[address]
    end

    def write_short(address, value)
      self[address] = value
    end

    def read_word(address)
      self[address] | (self[address + 1] << 8)
    end

    def write_word(address, value)
      write_short address, (value & 0xFF)
      write_short address + 1, (value >> 8)
    end
  end
end
