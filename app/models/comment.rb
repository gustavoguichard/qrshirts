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

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  belongs_to :author, :class_name => 'User', :foreign_key => "created_by"
  belongs_to :user, :counter_cache => true

  validates :note,              :presence => true,       :length => { :maximum => 1255 }
  validates :commentable_type,  :presence => true
  #validates :commentable_id,    :presence => true
end
