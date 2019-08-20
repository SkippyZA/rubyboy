module Rubyboy
  module Instructions
    module Load
      ####################################
      # 8 bit loads
      ####################################
      def load_nn_n(register)
        value = @mmu.read_short @pc
        set_register(register, value)
        @pc += 1
      end

      def ld_b_d8
        load_nn_n(:b)
      end

      def ld_c_d8
        load_nn_n(:c)
      end

      def ld_d_d8
        load_nn_n(:d)
      end

      def ld_e_d8
        load_nn_n(:e)
      end

      def ld_h_d8
        load_nn_n(:h)
      end

      def ld_l_d8
        load_nn_n(:l)
      end

      def load_r1_r2(register1, register2)
        value = instance_variable_get "@#{register2}"
        set_register register1, value
      end
    end
  end
end
