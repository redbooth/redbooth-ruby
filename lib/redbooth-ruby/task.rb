module RedboothRuby
  class Task < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :name,
                  :task_list_id,
                  :comments_count,
                  :assigned_id,
                  :is_private,
                  :project_id,
                  :urgent,
                  :user_id,
                  :position,
                  :last_activity_id,
                  :record_conversion_type,
                  :record_conversion_id,
                  :metadata,
                  :subtasks_count,
                  :resolved_subtasks_count,
                  :watcher_ids,
                  :description,
                  :description_html,
                  :description_updated_by_user_id,
                  :updated_by_id,
                  :deleted,
                  :status,
                  :due_on,
                  :created_at,
                  :updated_at

  end
end
