module Rubyboy
  class Emulator
    def self.run(rom)
      puts "Starting Rubyboy emulator..."

      rom = IO.binread(rom).bytes

      @cartridge = Cartridge.new rom
      @mmu = MMU.new rom
      @cpu = CPU.new @mmu
    end
  end
end
