module FileDb
  module System
    class Table
      attr_accessor :entries_index_by, :filename
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
            set_fieldnames remove_line_break(row).split(',')
          else
            set_entry row.split(',')
          end
        end
      end

      def find id
        hashed_by_id[id.to_s]
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
        hashed_by_id.keys.last.to_i + 1
      end

      def delete id
        hashed_by_id.delete(id.to_s)
        save_records!
      end

      def update_record object
        set_fieldnames(object.class.columns) if @fields.empty?
        data_to_save = {}
        @fieldnames.each_with_index do |column, column_index|
          field = @fields[column_index]
          data_to_save[field] = object.send(field)
        end
        unless object.persisted?
          data_to_save[:id] = next_id.to_s
          object.id = data_to_save[:id]
        end
        @entries_index_by[:id][object.id.to_s] = data_to_save
        save_records!
      end

      def save_records!
        headline = @fields.keys.map { |field_key| @fields[field_key] }.join(',')

        content = hashed_by_id.map do |index, entry|
          @fields.keys.map do |identifier|
            field = @fields[identifier]
            entry[field.to_sym]
          end.join(',')
        end.join("\n")

        @database.save_to_disk self, [headline, content].join("\n")
      end

      private



      def set_fieldnames fieldnames
        fieldnames.each_with_index do |column, column_index|
          symbol_column = remove_line_break(column).to_sym
          @fields[column_index] = symbol_column
          @fieldnames[symbol_column] = column_index
        end
      end

      def set_entry entry
        t_entry = {}
        entry.each_with_index do |column, column_index|
          t_entry[@fields[column_index].to_sym] = remove_line_break(column)
        end

        key_name = remove_line_break(entry[@fieldnames[:id]])

        @entries_index_by[:id][key_name.to_s] = t_entry
      end

      def remove_line_break value
        value.to_s.gsub "\n", ""
      end

    end
  end
end
