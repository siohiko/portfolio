require 'rails_helper'

RSpec.describe "Tops", type: :request do
  
  describe "GET /" do
    it "sucess request top page" do
      get root_path
      expect(response.status).to eq 200
      expect(response.body).to include 'TOP'
    end
  end
  
end
