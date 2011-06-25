module RestController
  module Routes
    def connect_resource(controller, options = {})
      configuration = { :by => [ :id ] }.update(options)

      requirements  = { :id => /\d+/, :controller => /(?:[a-z](?:-?[a-z]+)*)/ }
      requirements.merge!(configuration.delete(:requirements)) if configuration[:requirements]

      requirements[:action] ||= /(?!\A(?:new|collection|by_#{Regexp.union(*configuration[:by].map{ |a| a.to_s })})\z)(?:[a-z](?:[-_]?[a-z])*)/

      collection = controller.to_s.pluralize.gsub('_', '-')

      with_options(:controller => controller.to_s, :requirements => requirements) do |m|
        m.connect "#{configuration[:prefix]}#{collection}/new",     :action => 'new'
        m.connect "#{configuration[:prefix]}#{collection}/:action", :action => 'collection'

        configuration[:by].each do |attribute|
          m.connect "#{configuration[:prefix]}#{collection}/:#{attribute}/:action", :action => "by_#{attribute}"
        end
      end
    end
  end
end
