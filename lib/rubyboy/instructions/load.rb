module Rubyboy
  module Instructions
    module Load
      #####################################
      ## 8 bit loads
      #####################################
      def load_nn_n(register)
        value = @mmu.read_short @pc
        set_register(register, value)
      end

      def load_r1_r2(register1, register2)
        value = instance_variable_get "@#{register2}"
        set_register register1, value
      end

      def load_n_hl(n)
        value = @mmu.read_short hl
        set_register n, value
      end

      def load_hl_n(n)
        value = get_register n
        @mmu.write_short hl, value
      end
    end
  end
end
