module FileDb
  module System
    class Check
      def self.run!
        new.create_database_if_not_exist!
      end

      def create_database_if_not_exist!
        return if exist_data_directory?
        create_data_directory!
      end

      def exist_data_directory?
        File.exist? data_directory
      end

      def create_data_directory!
        Dir.mkdir data_directory
      end

      def data_directory
        Configuration.configured(:data_directory)
      end
    end
  end
end
