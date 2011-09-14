module BOSSMan
  class ResultSet < BaseValueObject
    
    def initialize(response)
      @response = response
      @boss_response = response['bossresponse']

      set_paramater('results', [])

      process_response
    end
    

    private

    def process_response
      @boss_response['web'].each do |key, value|
        case key
        when 'start', 'count', 'totalresults'
          set_parameter(key, value.to_i)
        when 'results'
          set_parameter(key, value.map { |result| Result.new(result) })
        else
          set_parameter(key, value)
        end        
      end
    end
  end  
end
