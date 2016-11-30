module FileDb
  module System
    class Database

      def initialize data_directory
        @data_directory = data_directory
        create_database_if_not_exist!
        load_tables!
      end

      def load_tables!
        @tables = {}
        Dir[File.join(@data_directory, "*.csv")].each do |filename|
          next unless File.file?(filename)
          load_table! filename
        end
      end

      def load_table! filename
        @tables[cleared_tablename(filename)] = Table.new(filename, self)
      end

      def create_database_if_not_exist!
        return if exist_data_directory?
        create_data_directory!
      end

      def drop_data_directory!
        Dir.remove @data_directory
      end

      private

      def cleared_tablename filename
        filename = filename.gsub '.csv', ''
        filename = filename.gsub @data_directory, ''
        filename = filename.gsub '/', ''
        filename.to_sym
      end

      def exist_data_directory?
        File.exist? @data_directory
      end

      def create_data_directory!
        Dir.mkdir @data_directory
      end

    end
  end
end
