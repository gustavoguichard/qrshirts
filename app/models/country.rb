# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  abbreviation     :string(5)
#  shipping_zone_id :integer
#  active           :boolean          default(FALSE)
#

class Country < ActiveRecord::Base

  has_many :states

  belongs_to :shipping_zone

  scope :active, where(:active => true)
  scope :inactive_countries, where(:active => false)

  validates :name,  :presence => true,       :length => { :maximum => 200 }
  validates :abbreviation,  :presence => true,       :length => { :maximum => 10 }

  USA_ID    = 214
  CANADA_ID = 35
  BRAZIL_ID = 28

  after_save :expire_cache

  ACTIVE_COUNTRY_IDS = [CANADA_ID, USA_ID, BRAZIL_ID]

  # Call this method to display the country_abbreviation - country with and appending name
  #
  # @example abbreviation == USA, country == 'United States'
  #   country.abbreviation_name(': capitalist') => 'USA - United States : capitalist'
  #
  # @param [append name, optional]
  # @return [String] country abbreviation - country name
  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end

  # Call this method to display the country_abbreviation - country
  #
  # @example abbreviation == USA, country == 'United States'
  #   country.abbrev_and_name => 'USA - United States'
  #
  # @param none
  # @return [String] country abbreviation - country name
  def abbrev_and_name
    abbreviation_name
  end

  # Finds all the countries for a form select .
  #
  # @param none
  # @return [Array] an array of arrays with [string, country.id]
  def self.form_selector
    Rails.cache.fetch("Country-form_selector") do
      data = Country.active.order('abbreviation ASC').all().map { |c| [c.abbrev_and_name, c.id] }
      data.blank? ? [[]] : data
    end
  end
  private
  def expire_cache
    Rails.cache.delete("Country-form_selector")
  end
end
