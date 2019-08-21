describe Rubyboy::MMU do
  subject { Rubyboy::MMU.new Array.new }

  context "using WRAM0" do
    it 'can read and write a byte' do
      subject[0xC001] = 0xA1
      subject[0xC002] = 0xB2

      expect(subject[0xC001]).to eq 0xA1
      expect(subject[0xC002]).to eq 0xB2
      expect(subject[0xC003]).to eq 0x00
    end

    it 'can read and write a word' do
      # write the word value (2 bytes)
      subject.write_word(0xC010, 0xA1B2)

      # check the word
      expect(subject.read_word(0xC010)).to eq 0xA1B2

      # make sure it is split across the memory correctly
      expect(subject.read_short(0xC010)).to eq 0xB2
      expect(subject.read_short(0xC011)).to eq 0xA1

      # ensure it didnt overflow to the next memory address
      expect(subject.read_short(0xC012)).to eq 0x00
    end
  end
end
