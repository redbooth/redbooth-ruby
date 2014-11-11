module RedboothRuby
  class Project < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

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
