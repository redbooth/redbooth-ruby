module Redbooth
  class Conversation < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

    attr_accessor :id,
                  :name,
                  :project_id,
                  :user_id,
                  :comments_count,
                  :is_private,
                  :last_activity_id,
                  :created_at,
                  :updated_at

  end
end
