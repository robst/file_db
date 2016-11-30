module FileDb
  module Query

    def find id
      new table.find(id)
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def all
      table.all.map{ |entry| new entry }
    end

    def where conditions
      table.where(conditions).map{ |entry| new entry }
    end

    def find_by attribute, search_value
      where("#{attribute}".to_sym => search_value).first
    end

  end
end
