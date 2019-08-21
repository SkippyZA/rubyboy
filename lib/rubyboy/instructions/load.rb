module Rubyboy
  module Instructions
    module Load
      #####################################
      ## 8 bit loads
      #####################################
      def load_nn_n(register)
        value = @mmu.read_short @pc
        set_register(register, value)
        # @pc += 1
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

      def load_a_n(n)

      end

      def ld_a_n() load_nn_n(:a) end
      def ld_b_n() load_nn_n(:b) end
      def ld_c_n() load_nn_n(:c) end
      def ld_d_n() load_nn_n(:d) end
      def ld_e_n() load_nn_n(:e) end
      def ld_h_n() load_nn_n(:h) end
      def ld_l_n() load_nn_n(:l) end

      def ld_a_a() load_r1_r2(:a, :a) end
      def ld_a_b() load_r1_r2(:a, :b) end
      def ld_a_c() load_r1_r2(:a, :c) end
      def ld_a_d() load_r1_r2(:a, :d) end
      def ld_a_e() load_r1_r2(:a, :e) end
      def ld_a_h() load_r1_r2(:a, :h) end
      def ld_a_l() load_r1_r2(:a, :l) end
      def ld_a_hl() load_n_hl(:a) end

      def ld_b_a() load_r1_r2(:b, :a) end
      def ld_b_b() load_r1_r2(:b, :b) end
      def ld_b_c() load_r1_r2(:b, :c) end
      def ld_b_d() load_r1_r2(:b, :d) end
      def ld_b_e() load_r1_r2(:b, :e) end
      def ld_b_h() load_r1_r2(:b, :h) end
      def ld_b_l() load_r1_r2(:b, :l) end
      def ld_b_hl() load_n_hl(:b) end

      def ld_c_a() load_r1_r2(:c, :a) end
      def ld_c_b() load_r1_r2(:c, :b) end
      def ld_c_c() load_r1_r2(:c, :c) end
      def ld_c_d() load_r1_r2(:c, :d) end
      def ld_c_e() load_r1_r2(:c, :e) end
      def ld_c_h() load_r1_r2(:c, :h) end
      def ld_c_l() load_r1_r2(:c, :l) end
      def ld_c_hl() load_n_hl(:c) end

      def ld_d_a() load_r1_r2(:d, :a) end
      def ld_d_b() load_r1_r2(:d, :b) end
      def ld_d_c() load_r1_r2(:d, :c) end
      def ld_d_d() load_r1_r2(:d, :d) end
      def ld_d_e() load_r1_r2(:d, :e) end
      def ld_d_h() load_r1_r2(:d, :h) end
      def ld_d_l() load_r1_r2(:d, :l) end
      def ld_d_hl() load_n_hl(:d) end

      def ld_e_a() load_r1_r2(:e, :a) end
      def ld_e_b() load_r1_r2(:e, :b) end
      def ld_e_c() load_r1_r2(:e, :c) end
      def ld_e_d() load_r1_r2(:e, :d) end
      def ld_e_e() load_r1_r2(:e, :e) end
      def ld_e_h() load_r1_r2(:e, :h) end
      def ld_e_l() load_r1_r2(:e, :l) end
      def ld_e_hl() load_n_hl(:e) end

      def ld_h_a() load_r1_r2(:h, :a) end
      def ld_h_b() load_r1_r2(:h, :b) end
      def ld_h_c() load_r1_r2(:h, :c) end
      def ld_h_d() load_r1_r2(:h, :d) end
      def ld_h_e() load_r1_r2(:h, :e) end
      def ld_h_h() load_r1_r2(:h, :h) end
      def ld_h_l() load_r1_r2(:h, :l) end
      def ld_h_hl() load_n_hl(:h) end

      def ld_l_a() load_r1_r2(:l, :a) end
      def ld_l_b() load_r1_r2(:l, :b) end
      def ld_l_c() load_r1_r2(:l, :c) end
      def ld_l_d() load_r1_r2(:l, :d) end
      def ld_l_e() load_r1_r2(:l, :e) end
      def ld_l_h() load_r1_r2(:l, :h) end
      def ld_l_l() load_r1_r2(:l, :l) end
      def ld_l_hl() load_n_hl(:l) end

      def ld_hl_a() load_hl_n(:a) end
      def ld_hl_b() load_hl_n(:b) end
      def ld_hl_c() load_hl_n(:c) end
      def ld_hl_d() load_hl_n(:d) end
      def ld_hl_e() load_hl_n(:e) end
      def ld_hl_h() load_hl_n(:h) end
      def ld_hl_l() load_hl_n(:l) end
    end
  end
end
