require 'singleton'
module FileDb
  class Database
    include Singleton

    def self.database_check!
      instance.create_data_directory! unless instance.exist_data_directory?
    end

    def exist_data_directory?
      File.exist? data_directory
    end

    def create_data_directory!
      Dir.mkdir data_directory
    end

    private

    def data_directory
      Configuration.configured(:data_directory)
    end
  end

end
