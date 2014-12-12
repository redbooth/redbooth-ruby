module RedboothRuby
  class TaskList < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete
    include RedboothRuby::Operations::Meta

    attr_accessor :id,
                  :name,
                  :project_id,
                  :user_id,
                  :start_on,
                  :finish_on,
                  :position,
                  :archived,
                  :archived_tasks_count,
                  :tasks_count,
                  :last_comment_id,
                  :updated_by_id,
                  :metadata,
                  :deleted,
                  :completed,
                  :created_at,
                  :updated_at
  end
end
