module Duralex
  class User

    def initialize(user)
      @user = user
    end

    def documents
      [*::Duralex.definitions[:documents].call(@user)]
    end

    def up_to_date?
      invalid_documents.empty?
    end

    def need_acceptation?
      !up_to_date?
    end

    def invalid_documents
      documents.reject { |doc| ::Duralex.definitions[:validation].call(@user, doc) }
    end

  end
end
