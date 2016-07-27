module FileDb
  module Query
    include FileDb::Columns
    include FileDb::Table
    def first
      all.first
    end

    def last
      all.last
    end

    def all
      where({})
    end

    def find id
      where(id: id).first
    end

    def where conditions
      results = []
      Database.instance.search(self) do |data_row|
        if conditions_match?(conditions,data_row)
          results << create_object(data_row)
        end
      end
      results
    end

private

    def create_object values
      hash = {}
      columns.each do |column|
        hash[column] = values[column_index(column)]
      end
      new hash
    end

    def conditions_match? conditions, data
      conditions.each do |key, value|
        return false unless data[column_index(key)].eql?(value.to_s)
      end
     true
    end

  end
end
