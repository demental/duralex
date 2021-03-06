require 'spec_helper'

RSpec.describe Duralex::Controller do

  before do
    allow(Duralex).to receive(:definitions).and_return({
      documents: Proc.new do |user|
        'some_tos'
      end,
      validation: Proc.new do |user, doc|
        user.terms_accepted_at > (Time.zone.now - 1.hour)
      end
    })
  end

  class DummyController < ActionController::Base
    include Duralex::Controller
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

      it 'does not raise Duralex::ExpiredTosError' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when user needs to validate' do
      let(:user) { double(accept_tos!: true, terms_accepted_at: (Time.zone.now - 2.hours)) }

      context 'out of tos path' do
        it 'raises Duralex::ExpiredTosError' do
          expect { subject }.to raise_error(Duralex::ExpiredTosError)
        end
      end
    end
  end
end
