module FileDb
  module Table

    def database
      DatabaseManager.instance.database
    end

    def table
      database.tables[table_name.to_sym]
    end

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
  end
end
