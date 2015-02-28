module Duralex

  class ExpiredTosError < StandardError ; end

  module Controller
    extend ActiveSupport::Concern
    included do
      rescue_from(Duralex::ExpiredTosError) do
        redirect_to Duralex.definitions[:path].call(self)
      end
    end

    def require_valid_tos!
      raise Duralex::ExpiredTosError if Duralex[current_user].need_acceptation?
    end
  end
end
