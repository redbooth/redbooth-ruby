module RedboothRuby
  class Note < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

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
                  :row_order,
                  :created_at,
                  :updated_at
  end
end
