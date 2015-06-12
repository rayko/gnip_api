module GnipApi
  module Apis
    module Search
      class Query
        attr_accessor :rules, :from_date, :to_date, :max_results, :next, :publisher
        
        def initialize params={}
          @rules = params[:rules]
          @from_date = params[:from_date]
          @to_date = params[:to_date]
          @max_results = params[:max_results]
          @next = params[:next]
          @publisher = params[:publisher]
        end

        def to_json
          hash = {}
          hash['query'] = @rules
          hash['publisher'] = @publisher
          hash['fromDate'] = @from_date.to_time.utc.strftime('%Y%m%d%H%M') if @from_date
          hash['toDate'] = @to_date.to_time.utc.strftime('%Y%m%d%H%M') if @to_date
          hash['next'] = @next if @next
          hash['maxResults'] = @max_results if @max_results
          hash.to_json
        end

        def valid?
        end

        private
        def validate
        end
      end
    end
  end
end
