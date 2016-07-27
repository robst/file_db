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
  end
end
