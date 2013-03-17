# == Schema Information
#
# Table name: deal_types
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DealType < ActiveRecord::Base
  attr_accessible :name

  validates :name,            :presence => true

  has_many :deals
  TYPES = ['Compre X ganhe % off', 'Compre X ganhe R$ off']
end
