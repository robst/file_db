module FileDb
  module Data
    def initialize params= {}
      before :initialize
      load_params_into_model params
      after :initialize
    end

    def delete
      before :delete
      table.delete(id)
      after :delete
    end

    def save
      before :save
      table.update_record self
      after :save
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
