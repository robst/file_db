module FileDb
  module Data
    def initialize params= {}
      load_params_into_model params
    end

    def delete
      Database.instance.delete_record self
    end

    def save
      if persisted?
        Database.instance.update_record self
      else
        self.id = Time.now.to_i
        Database.instance.add_record self
      end
    end

    def persisted?
      id
    end

private

    def load_params_into_model params
      params.each do |key, value|
        next unless self.class.columns.include?(key)
        send("#{key}=", value)
      end
    end

  end
end
