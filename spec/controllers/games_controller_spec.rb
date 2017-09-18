require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'game#index action' do
    
    it 'should successfully display "pending" games' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
