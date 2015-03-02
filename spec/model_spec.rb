require 'spec_helper'

RSpec.describe Duralex::Model do
  let(:time) { Time.zone.now }
  before     { Timecop.freeze(time) }

  it 'is set at user creation', pending: 'TODO setup basic AR environemnt for testing' do
    user = create_user
    expect(user.terms_accepted_at).to eq time
  end

  it 'isnt updated unless we specify it', pending: 'TODO setup basic AR environemnt for testing' do
    user = create_user
    Timecop.travel(time + T_1_HOUR)
    user.save!
    expect(user.terms_accepted_at).to eq time
  end

  it 'is set when calling accept_tos!', pending: 'TODO setup basic AR environemnt for testing' do
    user = create_user
    Timecop.freeze(time + T_1_HOUR)
    user.accept_tos!
    expect(user.terms_accepted_at).to eq(time + T_1_HOUR)
    expect(user.persisted?).to be_truthy
  end

  def create_user
  end
end
