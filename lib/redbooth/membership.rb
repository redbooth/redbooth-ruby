module Redbooth
  class Membership < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

    attr_accessor :id,
                  :user_id,
                  :organization_id,
                  :role,
                  :created_at,
                  :updated_at

  end
end
