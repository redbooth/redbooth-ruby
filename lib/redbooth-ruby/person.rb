module RedboothRuby
  class Person < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :user_id,
                  :project_id,
                  :role,
                  :created_at,
                  :updated_at

    # resource name
    # overwrite this in the model if the api is not well named
    #
    def self.api_resource_name(method = nil)
      'people'
    end
  end
end
