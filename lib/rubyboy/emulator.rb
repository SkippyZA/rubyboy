module Rubyboy
  class Emulator
    def initialize(rom_path)
      puts "Starting Rubyboy emulator..."

      rom = IO.binread(rom_path).bytes

      @cartridge = Cartridge.new rom
      @mmu = MMU.new @cartridge
      @cpu = CPU.new @mmu
    end

    def run
      30.times do
        @cpu.step
      end
    end
  end
end
