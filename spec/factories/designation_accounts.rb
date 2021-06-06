# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(FALSE)
#  balance    :decimal(, )      default(0.0)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

FactoryBot.define do
  factory :designation_account do
    name { Faker::Name.name }
  end
end
