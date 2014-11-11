module RedboothRuby
  class Organization < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :name,
                  :permalink,
                  :domain,
                  :settings,
                  :omit_email_processing,
                  :product,
                  :product_name,
                  :feature_level,
                  :subscription_id,
                  :seats,
                  :remaining_users,
                  :available_users,
                  :used_users,
                  :remaining_projects,
                  :available_projects,
                  :used_projects,
                  :has_logo,
                  :square_logo_url,
                  :top_logo_url,
                  :is_pro,
                  :created_at,
                  :updated_at

  end
end
