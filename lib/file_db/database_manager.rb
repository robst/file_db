require 'singleton'
module FileDb
  class DatabaseManager
    include Singleton

    attr_accessor :database

    def initialize
      @database = System::Database.new Configuration.configured(:data_directory)
    end
  end
end
