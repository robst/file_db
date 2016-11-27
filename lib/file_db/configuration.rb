module FileDb
  module Configuration
    def self.configure options = {}
      @configuration = default_options.merge(options)
      System::Check.run!
    end

    def self.configured option
      configuration[option]
    end

    def self.configuration
      @configuration ||= default_options
    end

    def self.default_options
      { data_directory: 'data'  }
    end
  end
end
