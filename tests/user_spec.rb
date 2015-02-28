require 'spec_helper'

RSpec.describe Terms::User do

  before do
    allow(Terms).to receive(:definitions).and_return({
      documents: Proc.new do |user|
        if user.admin?
          nil
        else
          if user.b2b?
            'some_tos'
          else
            ['some_tos', 'another_tos']
          end
        end
      end,
      validation: Proc.new do |user, doc|
        !user.refused_doc?
      end
    })
  end

  describe '#[]' do
    subject { Terms[user] }
    context 'with regular user' do
      let(:user) { build(:user) }
      it { expect(subject).to be_kind_of Terms::User }
    end
    context 'with nil user' do
      let(:user) { nil }
      it { expect(subject).to be_kind_of Terms::Guest }
    end
  end

  describe '#documents' do
    subject { Terms[user].documents }

    context 'with nil user' do
      let(:user)  { nil }
      it { expect(subject).to eq [] }
    end

    context 'with regular user' do
      context 'no tos' do
        let(:user) { double(accept_tos!: true, admin?: true) }
        it 'returns an empty array' do
          expect(subject).to eq []
        end
      end

      context 'one tos' do
        let(:user) { double(accept_tos!: true, admin?: false, b2b?: true) }
        it 'returns an array representation of the TOS definition' do
          expect(subject).to eq ['some_tos']
        end
      end

      context 'more tos' do
        let(:user) { double(accept_tos!: true, admin?: false, b2b?: false) }
        it 'returns an array representation of the TOS definition' do
          expect(subject).to eq ['some_tos', 'another_tos']
        end
      end
    end
  end

  describe '#up_to_date?' do
    subject { Terms[user].up_to_date? }
    context 'nil user' do
      let(:user) { nil }
      it { expect(subject).to be_truthy }
    end
  end
end
