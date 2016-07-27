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

    def add_record record
      ::CSV.open(table_file(record.class), "a") do |csv|
        csv << record.to_csv
      end
    end

    def exist_data_directory?
      File.exist? data_directory
    end

    def create_data_directory!
      Dir.mkdir data_directory
    end

    private

    def table_file model
      File.join(data_directory, "#{model.table_name}.csv")
    end

    def data_directory
      Configuration.configured(:data_directory)
    end
  end

end
