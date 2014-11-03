module Redbooth
  class User < Base
    include Redbooth::Operations::Index
    include Redbooth::Operations::Show

    attr_accessor :id, :email, :first_name, :last_name, :developer, :created_time,
      :emails, :storage, :confirmed, :user_id

    def id
      @id || @user_id
    end
  end
end
