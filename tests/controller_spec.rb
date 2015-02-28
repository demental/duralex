require 'spec_helper'

RSpec.describe Terms::Controller do

  before do
    allow(Terms).to receive(:definitions).and_return({
      documents: Proc.new do |user|
        'some_tos'
      end,
      validation: Proc.new do |user, doc|
        user.terms_accepted_at > (Time.zone.now - T_1_HOUR)
      end
    })
  end

  class DummyController < ActionController::Base
    include Terms::Controller
  end

  class TosOnlyController < DummyController
  end



  describe '#require_valid_tos!' do
    let(:controller) { DummyController.new }
    subject { controller.send(:require_valid_tos!) }

    before do
      allow(controller).to receive(:current_user).and_return user
    end

    context 'when user does not need to validate' do
      let(:user) { double(accept_tos!: true, terms_accepted_at: (Time.zone.now)) }

      it 'does not raise Terms::ExpiredTosError' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when user needs to validate' do
      let(:user) { double(accept_tos!: true, terms_accepted_at: (Time.zone.now - T_2_HOURS)) }

      context 'out of tos path' do
        it 'raises Terms::ExpiredTosError' do
          expect { subject }.to raise_error(Terms::ExpiredTosError)
        end
      end
    end
  end
end
