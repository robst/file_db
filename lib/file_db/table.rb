module FileDb
  module Table
    def table_name
      @table_name ||= self.new.class.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def set_table_name name
      @table_name = name
    end

    def searching_database
      return unless File.exist?(table_file_location)
      ::CSV.foreach(table_file_location) do |row| 
        yield row 
      end
    end

    def append_to_database entry_object
      ::CSV.open(table_file_location, "a") do |csv|
        csv << entry_object.to_csv
      end
    end

    def update_database entry_object
      records = []
      ::CSV.foreach(table_file_location) do |row|
        if row[0]==entry_object.id.to_s
          records << entry_object.to_csv
        else
          records << row
        end
      end

      ::CSV.open(table_file_location, "w") do |csv|
        records.each do |record|
          csv << record
        end
      end
    end

    def table_file_location
      File.join(Configuration.configured(:data_directory), "#{table_name}.csv")
    end
  end
end
