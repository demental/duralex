module Duralex
  module Model
    extend ActiveSupport::Concern

    included do
      before_create :accept_tos
      validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
    end

    def terms_of_service
      @terms_of_service
    end

    def terms_of_service=(term)
      @terms_of_service = term
    end

    def accept_tos!
      accept_tos and save!
    end

    def accept_tos
      self.terms_accepted_at = Time.zone.now
    end
  end
end
