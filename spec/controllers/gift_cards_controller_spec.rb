require "rails_helper"

describe GiftCardsController, :type => :controller do
  let(:current_user){ create(:user, state: "admin") }
  let(:company){ create(:company, user: current_user) }
  describe "POST create" do
    let(:gift_card) { build(:gift_card, company: company, user: current_user) }
    before(:each) do
      
    end

    describe "when user is logged in" do
      it "creates a gift card" do
        post :create, { locale: :pt, gift_card: gift_card.attributes, number: 1 }
        expect(GiftCard.count).to eq(1)
      end
    end
  end
end