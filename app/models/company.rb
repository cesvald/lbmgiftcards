class Company < ActiveRecord::Base
	has_many :gift_cards
	belongs_to :user

	validates_presence_of :name, :code
	validates_uniqueness_of :name, :code
end
