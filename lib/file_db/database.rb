require 'singleton'
module FileDb
  class Database
    include Singleton

    def self.database_check!
      instance.create_data_directory! unless instance.exist_data_directory?
    end

    def search model
      return unless File.exist?(table_file(model))
      ::CSV.foreach(table_file(model)) do |row|
        yield row
      end
    end

    def delete_record record
      records = []
      ::CSV.foreach(table_file(record.class)) do |row|
        next if row[0]==record.id.to_s
        records << build_object(record.class, row)
      end
      rebuild_table! record.class, records
    end

    def update_record record
      records = []
      ::CSV.foreach(table_file(record.class)) do |row|
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

    def exist_data_directory?
      File.exist? data_directory
    end

    def create_data_directory!
      Dir.mkdir data_directory
    end

    private

    def build_object clazz, data
      hash = {}
      clazz.columns.each do |column|
        hash[column] = data[clazz.column_index(column)]
      end
      clazz.new hash
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
