require 'singleton'
module FileDb
  class Database
    include Singleton

    def self.database_check!
      System::Check.run!
    end

    def search model
      return unless File.exist?(table_file(model))
      read_from_table model do |row|
        yield row
      end
    end

    def delete_record record
      records = []
      read_from_table record.class do |row|
        next if row[0]==record.id.to_s
        records << build_object(record.class, row)
      end

      rebuild_table! record.class, records
    end

    def update_record record
      records = []
      read_from_table record.class do |row|
        if row[0]==record.id.to_s
          records << record
        else
          records << build_object(record.class, row)
        end
      end
      rebuild_table! record.class, records
    end

    def add_record record
      write_to_table record.class, :a do
        record
      end
    end

    private

    def build_object clazz, data
      hash = {}
      clazz.columns.each do |column|
        hash[column] = data[clazz.column_index(column)]
      end
      clazz.new hash
    end

    def read_from_table clazz
      ::CSV.foreach(table_file(clazz)) do |row|
        yield(row)
      end
    end

    def write_to_table clazz, mode = 'w'
      ::CSV.open(table_file(clazz), mode.to_s) do |csv|
        [yield].flatten.each do |record|
          csv << record.to_csv
        end
      end
    end

    def rebuild_table! clazz, records
      write_to_table clazz do
        records
      end
    end

    def table_file model
      File.join(data_directory, "#{model.table_name}.csv")
    end

    def data_directory
      Configuration.configured(:data_directory)
    end
  end

end
