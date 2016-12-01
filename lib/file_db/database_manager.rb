require 'singleton'
module FileDb
  class DatabaseManager
    include Singleton

    attr_accessor :database

    def initialize
      @database = System::Database.new Configuration.configured(:data_directory)
    end

    def drop_database!
      database.drop_data_directory!
    end

    def create_database_if_not_exist!
      database.create_database_if_not_exist!
    end
  end
end
