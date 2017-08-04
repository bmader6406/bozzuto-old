require 'test_helper'

class ApartmentRoutesTest < ActionDispatch::IntegrationTest
  context "all apartment community-related routes" do
    before do
      @metro        = Metro.make
      @area         = Area.make(metro: @metro)
      @neighborhood = Neighborhood.make(area: @area)
      @community    = ApartmentCommunity.make(neighborhood: @neighborhood)
    end

    context "including the now unwanted /communities segment" do
      describe "GET /apartments/communities" do
        it "redirects to /apartments" do
          get '/apartments/communities'
          
          response.status.should eq 302

          should_redirect_to '/apartments'
        end
      end

      describe "GET /apartments/communities/:id" do
        it "redirects to /apartments/:id" do
          get "/apartments/communities/#{@metro.to_param}"
          
          response.status.should eq 301

          should_redirect_to "/apartments/#{@metro.to_param}"
        end
      end

      describe "GET /apartments/communities/:metro_id/:id" do
        it "redirects to /apartments/:metro_id/:id" do
          get "/apartments/communities/#{@metro.to_param}/#{@area.to_param}"
          
          response.status.should eq 301

          should_redirect_to "/apartments/#{@metro.to_param}/#{@area.to_param}"
        end
      end

      describe "GET /apartments/communities/:metro_id/:area_id/:id" do
        it "redirects to /apartments/:metro_id/:area_id/:id" do
          get "/apartments/communities/#{@metro.to_param}/#{@area.to_param}/#{@neighborhood.to_param}"
          
          response.status.should eq 301

          should_redirect_to "/apartments/#{@metro.to_param}/#{@area.to_param}/#{@neighborhood.to_param}"
        end
      end
    end

    describe "GET /apartments/communities/:id" do
      it "does not redirect when there's a matching apartment for the given ID" do
        get "/apartments/communities/#{@community.to_param}"

        response.status.should eq 200
      end
    end
  end

  def should_redirect_to(path)
    response.redirect_url.gsub("http://#{host}", '').should eq path
  end
end
