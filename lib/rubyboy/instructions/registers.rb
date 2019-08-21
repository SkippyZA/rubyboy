module Rubyboy
  module Instructions
    module Registers
      # af
      def af
        (@a << 8) | @f
      end

      def af=(val)
        @a = (val >> 8) & 0xFF
        @f = val & 0xFF
      end

      def bc
        (@b << 8) | @c
      end

      def bc=(val)
        @b = (val >> 8) & 0xff
        @c = val & 0xff
      end

      def de
        (@d << 8) | @e
      end

      def de=(val)
        @d = (val >> 8) & 0xff
        @e = val & 0xff
      end

      def hl
        (@h << 8) | @l
      end

      def hl=(val)
        @h = (val >> 8) & 0xff
        @l = val & 0xff
      end

      def set_z_flag
        @f |= Z_FLAG
      end

      def reset_z_flag
        @f &= Z_FLAG ^ 0xFF
      end

      def set_n_flag
        @f |= N_FLAG
      end

      def reset_n_flag
        @f &= N_FLAG ^ 0xFF
      end

      def set_h_flag
        @f |= H_FLAG
      end

      def reset_h_flag
        @f &= H_FLAG ^ 0xFF
      end

      def set_c_flag
        @f |= C_FLAG
      end

      def reset_c_flag
        @f &= C_FLAG ^ 0xFF
      end

      def set_program_counter (value)
        @pc = value
      end

      def get_register (register)
        if instance_variable_defined? "@#{register}"
          instance_variable_get "@#{register.to_sym}"
        elsif self.respond_to? "#{register}"
          self.send "#{register}"
        end
      end

      def set_register (register, value)
        if instance_variable_defined? "@#{register}"
          instance_variable_set "@#{register.to_sym}", value
        elsif self.respond_to? "#{register}="
          self.send "#{register}=", value
        end
      end
    end
  end
end
