# frozen_string_literal: true

require 'rails_helper'

describe Guest do
  subject(:guest) { build(:guest) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  describe 'email validations' do
    context 'when email is blank' do
      before do
        guest.email = ''
        guest.validate
      end

      it { is_expected.not_to be_valid }

      it 'adds a presence error on email' do
        expect(guest.errors[:email]).to include("can't be blank")
      end
    end

    context 'when email has invalid format' do
      before do
        guest.email = 'wayne_woodbridge#google'
        guest.validate
      end

      it { is_expected.not_to be_valid }
    end

    context 'when email is already taken (case-insensitive)' do
      before do
        create(:guest, email: 'wayne_woodbridge@bnb.com')
        guest.email = 'WAYNE_WOODBRIDGE@bnb.com'
      end

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe 'name validations' do
    context 'when first_name contains invalid characters' do
      before { guest.first_name = 'Wayne3!' }

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:first_name].first)
          .to match(/may only contain letters, spaces, hyphens, and apostrophes/)
      end
    end

    context 'when last_name contains invalid characters' do
      before { guest.last_name = 'Woodbridge@' }

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:last_name].first)
          .to match(/may only contain letters, spaces, hyphens, and apostrophes/)
      end
    end
  end

  describe 'phone_numbers_present validation' do
    context 'when phone_numbers is null' do
      before { guest.phone_numbers = nil }

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:phone_numbers])
          .to include('must include at least one phone number')
      end
    end

    context 'when phone_numbers is an empty array' do
      before { guest.phone_numbers = [] }

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:phone_numbers])
          .to include('must include at least one phone number')
      end
    end

    context 'when phone_numbers only has blank strings' do
      before { guest.phone_numbers = [ '', '' ] }

      it 'adds an error' do
        is_expected.not_to be_valid

        expect(guest.errors[:phone_numbers])
          .to include('must include at least one phone number')
      end
    end

    context 'when at least one phone number is present' do
      before { guest.phone_numbers = [ '', '639123456789' ] }

      it { is_expected.to be_valid }
    end
  end
end
