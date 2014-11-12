module RedboothRuby
  class File < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :name,
                  :backend,
                  :project_id,
                  :parent_id,
                  :backend_id,
                  :is_dir,
                  :is_downloadable,
                  :is_previewable,
                  :is_private,
                  :mime_type,
                  :public_token,
                  :pinned,
                  :size,
                  :user_id,
                  :created_at,
                  :updated_at

  end
end
