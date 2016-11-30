module FileDb
  module System
    class Table
      attr_accessor :entries_index_by
      def initialize filename, database
        @filename = filename
        @database = database
        @entries_index_by = {}
        @fields = {}
        @fieldnames = {}
        read_rows!
      end

      def read_rows!
        File.foreach(@filename).with_index do |row, row_index|
          if row_index == 0
            set_fieldnames row.split(',')
          else
            set_entry row.split(',')
          end
        end
      end

      def find id
        @entries_index_by[:id][id.to_s] || raise(RuntimeError, "Element not found id = #{id}")
      end

      def all
        entries_index_by[:id].values
      end

      def where conditions
        found_elements = all
        conditions.each do |key, value|
          found_elements = found_elements.select do |entry|
            entry[key.to_sym].eql?(value.to_s)
          end
        end
        found_elements
      end

      private

      def set_fieldnames fieldnames
        fieldnames.each_with_index do |column, column_index|
          symbol_column = clear_column_content(column).to_sym
          @fields[column_index] = symbol_column
          @fieldnames[symbol_column] = column_index
        end
      end

      def set_entry entry
        t_entry = {}
        entry.each_with_index do |column, column_index|
          t_entry[@fields[column_index].to_sym] = clear_column_content(column)
        end

        key_name = clear_column_content(entry[@fieldnames[:id]])
        @entries_index_by[:id] ||= {}
        @entries_index_by[:id][key_name.to_s] = t_entry
      end

      def clear_column_content column_name
        column_name.gsub "\n", ""
      end

    end
  end
end
