module RedboothRuby
  class Me < Base
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Delete

    attr_accessor :id, :email, :first_name, :last_name

    class << self
      def api_member_url(id = nil, method = nil)
        'me'
      end
    end

  end
end
