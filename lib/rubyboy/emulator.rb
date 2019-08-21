module Rubyboy
  class Emulator
    def initialize(rom_path)
      puts "Starting Rubyboy emulator..."

      rom = IO.binread(rom_path).bytes

      @cartridge = Cartridge.new rom
      @mmu = MMU.new rom
      @cpu = CPU.new @mmu
    end

    def run
      5000.times do
        @cpu.step
      end
    end
  end
end
