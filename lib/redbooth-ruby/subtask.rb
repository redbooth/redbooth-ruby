module RedboothRuby
  class Subtask < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :name,
                  :task_id,
                  :resolved,
                  :position,
                  :row_order,
                  :created_at,
                  :updated_at
  end
end
