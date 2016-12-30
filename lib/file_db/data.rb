module FileDb
  module Data
    def initialize params= {}
      load_params_into_model params
    end

    def delete
      table.delete(id)
    end

    def save
      table.update_record self
    end

    def persisted?
      table.hashed_by_id[id.to_s]
    end

    def table
      self.class.table
    end

private

    def load_params_into_model params
      params.each do |key, value|
        next unless self.class.columns_hash[key.to_sym]
        send("#{key}=", value)
      end
    end

  end
end
