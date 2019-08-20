describe Rubyboy::CPU do
  subject { Rubyboy::CPU.new }

  describe 'load instructions' do
    describe 'load_nn_n' do
      it 'stores the the value in the register' do
        subject.load_nn_n(:a, 0x11)
        expect(subject.a).to eq 0x11
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
  end

end
