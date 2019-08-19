module Rubyboy
  class Emulator
    def self.run(rom)
      puts "Starting Rubyboy emulator..."

      rom = IO.binread(rom).bytes

      @cartridge = Cartridge.new rom
      @mmu = MMU.new
      @cpu = CPU.new
    end
  end
end
