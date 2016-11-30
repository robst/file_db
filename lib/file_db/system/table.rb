module FileDb
  module System
    class Table
      attr_accessor :entries, :fields
      def initialize filename, database
        @filename = filename
        @database = database
        @indexes = [:id, :name]
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

        @indexes.each do |index|
          key_name = clear_column_content(entry[@fieldnames[index]])
          @entries_index_by[index] ||= {}
          @entries_index_by[index][key_name] = t_entry
        end

      end

      def clear_column_content column_name
        column_name.gsub "\n", ""
      end

    end
  end
end
