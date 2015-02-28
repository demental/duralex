require 'spec_helper'

RSpec.describe Terms::Model do
  let(:time) { Time.zone.now }
  before     { Timecop.freeze(time) }

  it 'is set at user creation' do
    user = create(:user)
    expect(user.terms_accepted_at).to eq time
  end

  it 'isnt updated unless we specify it' do
    user = create(:user)
    Timecop.travel(time + T_1_HOUR)
    user.save!
    expect(user.terms_accepted_at).to eq time
  end

  it 'is set when calling accept_tos!' do
    user = create(:user)
    Timecop.freeze(time + T_1_HOUR)
    user.accept_tos!
    expect(user.terms_accepted_at).to eq(time + T_1_HOUR)
    expect(user.persisted?).to be_truthy
  end

end
