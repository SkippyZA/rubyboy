describe Rubyboy::Instructions::Registers do
  before(:each) { @mmu = Rubyboy::MMU.new [] }
  subject { Rubyboy::CPU.new @mmu }

  describe 'when reading 16 bit registers' do
    it 'pairs the A, F registers to form a AF' do
      subject.set_register :a, 0x5
      subject.set_register :f, 0x3
      expect(subject.af).to eq 0x503
    end

    it 'pairs the B, C registers to form a BC' do
      subject.set_register :b, 0x5
      subject.set_register :c, 0x3
      expect(subject.bc).to eq 0x503
    end

    it 'pairs the D, E registers to form a DE' do
      subject.set_register :d, 0x5
      subject.set_register :e, 0x3
      expect(subject.de).to eq 0x503
    end

    it 'pairs the H, L registers to form a HL' do
      subject.set_register :h, 0x5
      subject.set_register :l, 0x3
      expect(subject.hl).to eq 0x503
    end
  end

  describe 'when setting 16 bit registers' do
    it 'sets the A, F registers when setting AF' do
      subject.af = 0x503
      expect(subject.a).to eq 0x5
      expect(subject.f).to eq 0x3
    end

    it 'sets the B, C registers when setting BC' do
      subject.bc = 0x503
      expect(subject.b).to eq 0x5
      expect(subject.c).to eq 0x3
    end

    it 'sets the D, E registers when setting DE' do
      subject.de = 0x503
      expect(subject.d).to eq 0x5
      expect(subject.e).to eq 0x3
    end

    it 'sets the H, L registers when setting HL' do
      subject.hl = 0x503
      expect(subject.h).to eq 0x5
      expect(subject.l).to eq 0x3
    end
  end

  describe 'Z flag' do
    describe 'when setting the flag' do
      it 'sets the flag' do
        subject.set_z_flag

        expect(subject.f).to eq 0b1000_0000
      end

      it 'does not modify other flags' do
        subject.set_register :f, 0b0011_0000
        subject.set_z_flag

        expect(subject.f).to eq 0b1011_0000
      end
    end

    describe 'when resetting the flag' do
      it 'resets the flag' do
        subject.set_register :f, 0b1000_0000
        subject.reset_z_flag

        expect(subject.f).to eq 0b0000_0000
      end

      it 'does not reset other flags' do
        subject.set_register :f, 0b1011_0000
        subject.reset_z_flag

        expect(subject.f).to eq 0b0011_0000
      end
    end
  end

  describe 'N flag' do
    describe 'when setting the flag' do
      it 'sets the flag' do
        subject.set_n_flag

        expect(subject.f).to eq 0b0100_0000
      end

      it 'does not modify other flags' do
        subject.set_register :f, 0b0011_0000
        subject.set_n_flag

        expect(subject.f).to eq 0b0111_0000
      end
    end

    describe 'when resetting the flag' do
      it 'resets the flag' do
        subject.set_register :f, 0b1000_0000
        subject.reset_z_flag

        expect(subject.f).to eq 0b0000_0000
      end

      it 'does not reset other flags' do
        subject.set_register :f, 0b1011_0000
        subject.reset_z_flag

        expect(subject.f).to eq 0b0011_0000
      end
    end
  end

  describe 'H flag' do
    describe 'when setting the flag' do
      it 'sets the flag' do
        subject.set_h_flag

        expect(subject.f).to eq 0b0010_0000
      end

      it 'does not modify other flags' do
        subject.set_register :f, 0b1001_0000
        subject.set_h_flag

        expect(subject.f).to eq 0b1011_0000
      end
    end

    describe 'when resetting the flag' do
      it 'resets the flag' do
        subject.set_register :f, 0b0010_0000
        subject.reset_h_flag

        expect(subject.f).to eq 0b0000_0000
      end

      it 'does not reset other flags' do
        subject.set_register :f, 0b1011_0000
        subject.reset_h_flag

        expect(subject.f).to eq 0b1001_0000
      end
    end
  end

  describe 'C flag' do
    describe 'when setting the flag' do
      it 'sets the flag' do
        subject.set_c_flag

        expect(subject.f).to eq 0b0001_0000
      end

      it 'does not modify other flags' do
        subject.set_register :f, 0b1010_0000
        subject.set_c_flag

        expect(subject.f).to eq 0b1011_0000
      end
    end

    describe 'when resetting the flag' do
      it 'resets the flag' do
        subject.set_register :f, 0b0001_0000
        subject.reset_c_flag

        expect(subject.f).to eq 0b0000_0000
      end

      it 'does not reset other flags' do
        subject.set_register :f, 0b1011_0000
        subject.reset_c_flag

        expect(subject.f).to eq 0b1010_0000
      end
    end
  end
end
