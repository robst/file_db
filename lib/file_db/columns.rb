module FileDb
  module Columns

    def columns *names
      return @columns if names.empty?
      names.delete(:id)
      @columns = [:id] + names

      @columns_hash = {}
      @columns.each do |name|
        @columns_hash[name] = true
        define_method name do
          instance_variable_get "@#{name}"
        end
        define_method "#{name}=" do |new_val|
          instance_variable_set "@#{name}", new_val
        end
      end

    end

    def column_index column
      @columns.index column
    end

    def columns_hash
      @columns_hash
    end
  end
end
