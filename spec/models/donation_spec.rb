# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                     :uuid             not null, primary key
#  amount                 :decimal(, )
#  currency               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  donor_account_id       :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_donations_on_designation_account_id  (designation_account_id)
#  index_donations_on_donor_account_id        (donor_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (donor_account_id => donor_accounts.id) ON DELETE => cascade
#

require 'rails_helper'

RSpec.describe Donation, type: :model do
  subject(:donation) { create(:donation) }

  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:donor_account) }

  describe '.by_date_range' do
    let!(:old_donation) { create(:donation, created_at: 2.years.ago) }
    let!(:new_donation) { create(:donation) }

    it 'returns all donations' do
      expect(described_class.by_date_range(nil, nil)).to match_array([old_donation, new_donation])
    end

    it 'returns new donation when date_from' do
      expect(described_class.by_date_range(1.year.ago, nil)).to match_array([new_donation])
    end

    it 'returns old donation when date_to' do
      expect(described_class.by_date_range(nil, 1.year.ago)).to match_array([old_donation])
    end

    it 'returns old donation when date_from and date_to' do
      expect(described_class.by_date_range(3.years.ago, 1.year.ago)).to match_array([old_donation])
    end
  end

  describe '.as_csv' do
    let!(:d1) { create(:donation, created_at: 2.years.ago) }
    let!(:d2) { create(:donation) }

    it 'returns csv' do
      expect(described_class.as_csv).to eq(
        <<~CSV
          PEOPLE_ID,ACCT_NAME,DISPLAY_DATE,AMOUNT,DONATION_ID,DESIGNATION,MOTIVATION,PAYMENT_METHOD,MEMO,TENDERED_AMOUNT,TENDERED_CURRENCY,ADJUSTMENT_TYPE
          #{d1.donor_account_id},#{d1.donor_account.name},#{d1.created_at.strftime('%m/%d/%Y')},#{d1.amount},#{d1.id},#{d1.designation_account_id},"","","",#{d1.amount},#{d1.currency},""
          #{d2.donor_account_id},#{d2.donor_account.name},#{d2.created_at.strftime('%m/%d/%Y')},#{d2.amount},#{d2.id},#{d2.designation_account_id},"","","",#{d2.amount},#{d2.currency},""
        CSV
      )
    end
  end
end
