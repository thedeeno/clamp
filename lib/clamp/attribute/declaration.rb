module Clamp
  module Attribute

    module Declaration

      protected

      def define_accessors_for(attribute, &block)
        define_reader_for(attribute)
        define_default_for(attribute)
        define_writer_for(attribute, &block)
        define_multi_writer_for(attribute) if attribute.multivalued?
      end

      def define_reader_for(attribute)
        define_method(attribute.read_method) do
          attribute.of(self)._read
        end
      end

      def define_default_for(attribute)
        define_method(attribute.default_method) do
          attribute.default_value
        end
      end

      def define_writer_for(attribute, &block)
        define_method(attribute.write_method) do |value|
          if block
            value = instance_exec(value, &block)
          end
          attribute.of(self)._write(value)
        end
      end

      def define_multi_writer_for(attribute)
        define_method(attribute.multi_write_method) do |values|
          attribute.of(self).set([])
          Array(values).each do |value|
            attribute.of(self).write(value)
          end
        end
      end

    end

  end
end
