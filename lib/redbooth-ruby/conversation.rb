module RedboothRuby
  class Conversation < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

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
