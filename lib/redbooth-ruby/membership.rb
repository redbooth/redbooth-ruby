module RedboothRuby
  class Membership < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :user_id,
                  :organization_id,
                  :role,
                  :created_at,
                  :updated_at

  end
end
