module Rubyboy
  class MMU
    # 0000h – 3FFFh [ ROM0  ] Non-switchable ROM Bank. 
    # 4000h – 7FFFh [ ROMX  ] Switchable ROM bank. 
    # 8000h – 9FFFh [ VRAM  ] Video RAM, switchable (0-1) in GBC mode. 
    # A000h – BFFFh [ SRAM  ] External RAM in cartridge, often battery buffered. 
    # C000h – CFFFh [ WRAM0 ] Work RAM. 
    # D000h – DFFFh [ WRAMX ] Work RAM, switchable (1-7) in GBC mode 
    # E000h – FDFFh [ ECHO  ] Description of the behaviour below. 
    # FE00h – FE9Fh [ OAM   ] (Object Attribute Table) Sprite information table. 
    # FEA0h – FEFFh [ UNUSED] Description of the behaviour below. 
    # FF00h – FF7Fh [ I/O   ] Registers I/O registers are mapped here. 
    # FF80h – FFFEh [ HRAM  ] Internal CPU RAM 
    # FFFFh         [ IE    ] Register Interrupt enable flags.
  end
end
