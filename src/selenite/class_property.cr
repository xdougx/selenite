module ClassProperty
  macro class_property(*names)
    class_getter {{*names}}
    class_setter {{*names}}
  end

  macro class_property?(*names)
    class_getter? {{*names}}
    class_setter {{*names}}
  end

  macro class_property!(*names)
    getter! {{*names}}
    setter {{*names}}
  end

  macro class_setter(*names)
    {% for name in names %}
      def self.{{name}}=(value)
        @@{{name}} = value
      end
    {% end %}
  end

  macro class_getter(*names)
    {% for name in names %}
      def self.{{name}}
        @@{{name}}
      end
    {% end %}
  end

  macro class_getter?(*names)
    {% for name in names %}
      def {{name}}?
        @@{{name}}
      end
    {% end %}
  end

  macro class_getter!(*names)
    {% for name in names %}
      def {{name}}?
        @@{{name}}
      end

      def {{name}}
        @@{{name}}.not_nil!
      end
    {% end %}
  end
end

