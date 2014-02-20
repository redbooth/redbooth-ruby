module Redbooth
  class Me < Base
    include Redbooth::Operations::Show

    attr_accessor :id, :email, :first_name, :last_name

    class << self
      def api_member_url(id = nil, method = nil)
        'me'
      end
    end

  end
end
