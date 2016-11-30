module FileDb
  module System
    class Table
      attr_accessor :entries_index_by
      def initialize filename, database
        @filename = filename
        @database = database
        @entries_index_by = {}
        @entries_index_by[:id] = {}
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
        hashed_by_id[id.to_s] || raise(RuntimeError, "Element not found id = #{id}")
      end

      def all
        hashed_by_id.values
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

      def hashed_by_id
        entries_index_by[:id]
      end

      def next_id
        hashed_by_id.keys.sort.last.to_i + 1
      end

      def delete id
        hashed_by_id.delete(id.to_s)
        # dump
      end

      def update_record object
        data_to_save = {}
        @fieldnames.each_with_index do |column, column_index|
          field = @fields[column_index]
          data_to_save[field] = object.send(field)
        end
        if object.persisted?
          @entries_index_by[:id][object.id.to_s] = data_to_save
        else
          @entries_index_by[:id][next_id.to_s] = data_to_save
        end

        # dump
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

        @entries_index_by[:id][key_name.to_s] = t_entry
      end

      def clear_column_content column_name
        column_name.gsub "\n", ""
      end

    end
  end
end
