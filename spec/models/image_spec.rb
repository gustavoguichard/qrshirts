# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  position   :integer
#  caption    :string(255)
#  updated_at :datetime
#  created_at :datetime
#  image_id   :string(255)      default(""), not null
#  product_id :integer          not null
#

require 'spec_helper'

describe Image, '.find_dimensions' do
  pending "add some find_dimensions"
end
