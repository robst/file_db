module FileDB
  module Database
    def self.database_check!
      create_data_directory! unless exist_data_directory?
    end
    
    private
    def self.data_directory
      Configuration.configured(:data_directory)
    end

    def self.exist_data_directory?
      File.exist? data_directory
    end

    def self.create_data_directory!
      Dir.mkdir data_directory
    end
  end
end
