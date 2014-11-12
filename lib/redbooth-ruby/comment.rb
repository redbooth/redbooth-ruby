module RedboothRuby
  class Comment < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :body,
                  :body_html,
                  :project_id,
                  :user_id,
                  :target_id,
                  :target_type,
                  :minutes,
                  :upload_ids,
                  :assigned_id,
                  :previous_assigned_id,
                  :due_on,
                  :previous_due_on,
                  :is_private,
                  :previous_is_private,
                  :urgent,
                  :previous_urgent,
                  :email_id,
                  :time_tracking_on,
                  :status,
                  :previous_status,
                  :created_at,
                  :updated_at

  end
end
