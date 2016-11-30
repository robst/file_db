module FileDb
  module System
    class Table
      def initialize filename, database
        @filename = filename
        @database = database
      end
    end
  end
end
