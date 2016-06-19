module FileDb
  module Data
    def initialize params= {}
      load_params_into_model params
    end


    def load_params_into_model params
      params.each do |key, value|
        next unless self.class.columns.include?(key)
        send("#{key}=", value)
      end 
    end

    def create params
      load_params_into_model params
      save
      self
    end
    
    def save
      if persisted?
        self.class.update_database self
      else
        self.id = Time.now.to_i
        self.class.append_to_database self
      end
    end


    def persisted?
      id
    end
  end  
end
