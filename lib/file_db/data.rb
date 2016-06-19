module FileDb
  module Data
    def initialize params= {}
      params.each do |key, value|
        next unless self.class.columns.include?(key)
        send("#{key}=", value)

      end 
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
      !id.nil?
    end
  end  
end
