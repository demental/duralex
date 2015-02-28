# @TODO until we move this to a gem, the module is loaded in the initializer
# to avoid destroying configuration in development mode (cache_class=false)

require "duralex/controller"
require "duralex/guest"
require "duralex/model"
require "duralex/user"

module Duralex

  extend self

  @definitions = {}

  attr_reader :definitions

  def [](user)
    user.respond_to?(:accept_tos!) ? Duralex::User.new(user) : Duralex::Guest.new
  end

  def define(&block)
    instance_eval(&block)
  end

  private

  def documents(&block)
    self.definitions[:documents] = block
  end

  def validation(&block)
    self.definitions[:validation] = block
  end

  def path(&block)
    self.definitions[:path] = block
  end
end
