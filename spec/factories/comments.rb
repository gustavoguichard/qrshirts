# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  note             :text
#  commentable_type :string(255)
#  commentable_id   :integer
#  created_by       :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :comment do
    note "My Note"
    commentable { |c| c.association(:return_authorization) }
    created_by  { |c| c.association(:user).id }
    user        { |c| c.association(:user) }
  end
end
