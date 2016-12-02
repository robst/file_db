module FileDb
  module Query

    def find id
      found_element = table.find(id)
      return unless found_element
      new found_element
    end

    def first
      found_element = table.first
      return unless found_element
      new found_element
    end

    def last
      found_element = table.last
      return unless found_element
      new found_element
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
