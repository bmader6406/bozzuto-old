module SimplifiHelper
  def apartment_contact_simplifi_code
    <<-END.html_safe
      <script async src="//i.simpli.fi/dpx.js?cid=3345&conversion=10&campaign_id=0&m=1"></script>
      <img src="//i.simpli.fi/dpx?cid=3345&conversion=10&campaign_id=0" width="1" height="1">
    END
  end
end
