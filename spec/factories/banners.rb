# == Schema Information
#
# Table name: banners
#
#  id         :integer          not null, primary key
#  image_id   :string(255)      not null
#  link_url   :string(255)      not null
#  starts_at  :datetime         default(2013-03-16 17:02:50 UTC), not null
#  ends_at    :datetime         default(2013-03-16 17:02:50 UTC), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :banner do
    image_id "MyString"
    link_url "MyString"
    active false
  end
end
