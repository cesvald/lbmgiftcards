class AddCompanyAndExpirationDays < ActiveRecord::Migration
  def change
  	add_column :gift_cards, :company_id, :integer
  	add_column :gift_cards, :expiration_days, :integer
  end
end
