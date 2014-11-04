module Redbooth
  class Organization < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Create
    include Redbooth::Operations::Update
    include Redbooth::Operations::Show
    include Redbooth::Operations::Delete

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
