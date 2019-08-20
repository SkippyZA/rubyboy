describe Rubyboy::MMU do
  subject { Rubyboy::MMU.new Array.new }

  it 'can read and write a byte' do
    subject[0x00] = 0xA1
    subject[0x01] = 0xB2

    expect(subject[0x00]).to eq 0xA1
    expect(subject[0x01]).to eq 0xB2
    expect(subject[0x02]).to eq 0x00
  end

  it 'can read and write a word' do
    # write the word value (2 bytes)
    subject.write_word(0x10, 0xA1B2)

    # check the word
    expect(subject.read_word(0x10)).to eq 0xA1B2

    # make sure it is split across the memory correctly
    expect(subject.read_short(0x10)).to eq 0xB2
    expect(subject.read_short(0x11)).to eq 0xA1

    # ensure it didnt overflow to the next memory address
    expect(subject.read_short(0x12)).to eq 0x00
  end
end
