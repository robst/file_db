module FileDb
  module Filter
    module ClassMethods
      def before type, &block
        raise 'no block given' unless block_given?
        add_filter :before, type, &block
      end

      def after type, &block
        raise 'no block given' unless block_given?
        add_filter :after, type, &block
      end

      def file_db_filters
        @file_db_filters
      end

      private

      def add_filter runtime, type, &block
        @file_db_filters ||= init_filter
        @file_db_filters[runtime.to_sym][type.to_sym] << block
      end

      def init_filter
        { before: Hash.new([]), after: Hash.new([]) }
      end

    end

    module InstanceMethods
      def before type
        run_filters :before, type
      end

      def after type
        run_filters :after, type
      end

      private

      def run_filters runtime, type
        return unless file_db_filters(runtime)
        file_db_filters(runtime)[type.to_sym].each do |filter|
          filter.call(self)
        end
      end

      def file_db_filters runtime
        self.class.file_db_filters && self.class.file_db_filters[runtime.to_sym]
      end

    end
  end
end
