module HomeCommunitiesHelper
  def render_homes_listings(communities, locals = {})
    options = {
      :partial    => "home_communities/listing",
      :collection => communities,
      :as         => :community,
      :locals     => locals.reverse_merge({
        :use_dnr => false
      })
    }

    render options
  end

  def zillow_mortgage_calculator
    '<div style="width:230px;overflow:hidden;text-align:center;font-family:verdana,arial,sans-serif;font-size:8pt;line-height:13x;background-color:#c2c6ca;letter-spacing:0;text-transform:none;"> <div style="margin:6px 0;"> <a href="http://www.zillow.com/mortgage/calculator/Calculators.htm#{scid=gen-wid-sold}" target="_blank" title="Mortgage Calculators on Zillow" style="font-size:8pt;text-decoration:none;font-weight:bold;color:#fff;cursor: pointer;display: block;text-align: center;"> Mortgage Calculator</a> </div> <div style="width:228px;height:253px;margin:0;background-color:#fff;border:1px solid #c2c6ca;border-width:0 1px;text-align:left; font-size:8pt;"> <iframe title="Mortgage Calculator" frameborder="0" height="253px" style="float:left;" scrolling="no" width="228" src="http://www.zillow.com/mortgage/MortgageLoanCalculatorWidget.htm?skin=custom&price=400000&wtype=spc&rid=102001&wsize=small&textcolor=636972"> Your browser doesn\'t support frames. Visit <a href="http://www.zillow.com/mortgage/calculator/Calculators.htm#{scid=mor-wid-spcalc}" target="_blank" style="text-decoration:none; font-size:9pt; font-weight:bold;">Zillow Mortgage Calculators</a> to see this content. </iframe> <div style="clear:both;"></div> </div> <div style="width:230px;height:20px;"> <span style="display:block;margin:0 auto;font-size:7pt;height:15px;width:230px;color:#fff;padding-top:2px;"> <a href="http://www.zillow.com/mortgage/#{scid=mor-wid-spcalc}" target="_blank" title="Mortgages on Zillow" style="text-decoration:none;color:#fff;">Mortgages</a> on Zillow </span></div></div>'.html_safe
  end
end
