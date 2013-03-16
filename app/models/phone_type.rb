# == Schema Information
#
# Table name: phone_types
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class PhoneType < ActiveRecord::Base
  has_many :phones

  validates :name, :presence => true,       :length => { :maximum => 25 }

  # Type of possible phones, used in dropdowns and seed values
  NAMES = ['Cell', 'Home', 'Work', 'Other']

end
