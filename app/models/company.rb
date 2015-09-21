class Company < ActiveRecord::Base
	has_many :gift_cards
	belongs_to :user

	validates_presence_of :name, :code
	validates_uniqueness_of :name, :code

	mount_uploader :gift_card_template, ImageUploader
end