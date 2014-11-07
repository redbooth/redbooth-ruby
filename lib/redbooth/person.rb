module Redbooth
  class Person < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

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