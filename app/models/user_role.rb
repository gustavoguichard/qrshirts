# == Schema Information
#
# Table name: user_roles
#
#  id      :integer          not null, primary key
#  role_id :integer          not null
#  user_id :integer          not null
#

class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

 # validates :user_id,  :presence => true
  validates :role_id,  :presence => true

end
