module FileDb
  module Table
    def table_name
      @table_name ||= self.new.class.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def set_table_name name
      @table_name = name
    end

    def create params
      object = new params
      object.save
      object
    end

    def rebuild_file! entries
      ::CSV.open(table_file_location, "w") do |csv|
        entries.each do |entry|
          csv << entry
        end
      end
    end

    def delete_entry entry
      records = []
      ::CSV.foreach(table_file_location) do |row|
        next if row[0]==entry.id.to_s
        records << row
      end
      rebuild_file! records
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
      rebuild_file! records
    end

    def table_file_location
      File.join(Configuration.configured(:data_directory), "#{table_name}.csv")
    end
  end
end
