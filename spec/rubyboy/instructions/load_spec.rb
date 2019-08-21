describe Rubyboy::Instructions::Registers do
  before(:each) do
    @mmu = Rubyboy::MMU.new []
  end

  subject { Rubyboy::CPU.new @mmu }

  describe '8 bit load instructions' do
    describe 'load_nn_n' do
      it 'reads the next 8 bytes and puts them into register A' do
        subject.set_program_counter(0xFF10)
        @mmu[subject.pc] = 0xAF

        subject.load_nn_n(:a)

        expect(subject.a).to eq 0xAF
      end
    end

    describe 'load_r1_r2' do
      it 'puts the value from r2 into r1' do
        subject.set_register(:a, 0x11)
        subject.set_register(:b, 0x22)

        subject.load_r1_r2(:a, :b)

        expect(subject.a).to eq 0x22
      end
    end

    describe 'load_n_hl' do
      it 'puts memory from location n into HL' do
        subject.hl = 0xAA10
        @mmu.write_short(subject.hl, 0xAF)

        subject.load_n_hl(:b)

        expect(subject.b).to eq 0xAF
      end
    end

    describe 'load_hl_n' do
      it 'puts the value at memory location in HL to register' do
        n = 0xAA10

        subject.hl = n
        subject.set_register(:b, 0xAF)

        subject.load_hl_n(:b)

        expect(@mmu.read_short n).to eq 0xAF
      end
    end
  end
end
