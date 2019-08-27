module Rubyboy
  class Cartridge
    def initialize(rom)
      @rom = rom
    end

    def [](address)
      @rom[address]
    end

    def []=(address, value)
      @rom[address] = value
    end
  end
end
