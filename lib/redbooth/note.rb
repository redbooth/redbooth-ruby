module Redbooth
  class Note < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

    attr_accessor :id,
                  :name,
                  :project_id,
                  :content,
                  :user_id,
                  :position,
                  :permalink,
                  :is_private,
                  :shared,
                  :token,
                  :updated_by_id,
                  :deleted,
                  :created_at,
                  :updated_at

  end
end
