module Redbooth
  class Project < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

    attr_accessor :id,
                  :permalink,
                  :organization_id,
                  :archived,
                  :name,
                  :description,
                  :start_date,
                  :end_date,
                  :tracks_time,
                  :public,
                  :publish_pages,
                  :settings,
                  :deleted,
                  :created_at,
                  :updated_at

  end
end
