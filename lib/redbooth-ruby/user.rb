module RedboothRuby
  class User < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Show

    attr_accessor :id, :email, :first_name, :last_name, :developer, :created_time,
      :emails, :storage, :confirmed, :user_id

    def id
      @id || @user_id
    end
  end
end
