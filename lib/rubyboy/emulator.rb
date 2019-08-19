module Rubyboy
  class Emulator
    def self.run(rom)
      puts "Starting Rubyboy emulator..."

      @mmu = MMU.new
      @cpu = CPU.new
    end
  end
end
