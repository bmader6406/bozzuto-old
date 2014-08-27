module RedirectRules
  class << self
    def each
      list.each { |rule| yield rule.components }
    end

    def list
      [
        Rule.new(%r{^/cs/bozzuto_homes/housing_for_all/?},       '/about-us/housing-for-all'),
        Rule.new(%r{^/cs/root/corporate/rent_a_home/overview/?}, '/apartments'),
        Rule.new(%r{^/cs/root/corporate/homes/?},                '/new-homes'),
        Rule.new(%r{^/cs/_corporate/about_us/housing_for_all/?}, '/about-us/housing-for-all'),
        Rule.new(%r{^/cs/_corporate/about_us/?},                 '/about-us'),
        Rule.new(%r{^/cs/_corporate/acquisitions/?},             '/services/acquisitions'),
        Rule.new(%r{^/cs/_corporate/construction/?},             '/services/construction'),
        Rule.new(%r{^/cs/root/corporate/development/?},          '/services/development'),
        Rule.new(%r{^/cs/bozzuto_homes/?},                       '/services/homebuilding'),
        Rule.new(%r{^/cs/land/land_home/?},                      '/services/land'),
        Rule.new(%r{^/cs/root/corporate/management/?},           '/services/management'),
        Rule.new(%r{^/cs/root/corporate/contact_us/?},           '/about-us/contact'),
        Rule.new(%r{^/cs/corporate/aboutus/housing_for_all/?},   '/about-us/housing-for-all'),
        Rule.new(%r{^/cs/BozzutoElite/?},                        '/apartments/bozzuto-elite'),
        Rule.new(%r{^/cs/BozzutoSmartRent/?},                    '/apartments/smartrent'),
        Rule.new(%r{^/cs/root/corporate/rent_a_home/awards/?},   '/about-us/awards'),
        Rule.new(%r{^/cs/root/corporate/rent_a_home/news/?},     '/about-us/news'),
        Rule.new(%r{^/cs/root/corporate/careers/?},              '/careers'),
        Rule.new(%r{^/cs/search_properties/?},                   '/apartments/communities'),
        Rule.new(%r{^/property/?},                               '/apartments'),
        Rule.new(%r{^/smartrent/?},                              '/apartments/smartrent'),
        Rule.new(%r{^/about-us/careers(.*)},                     '/careers$1'),
        Rule.new(%r{^/regions/arlington-va-washington-dc/?},     '/regions/arlington-apartments'),
        Rule.new(%r{^/regions/washington-dc-apartments/?},       '/apartments/communities/washington-dc-metro#.U6hy2-g5DuQ'),
        Rule.new(%r{^/regions/maryland-communities/?},           '/apartments/communities/baltimore-annapolis-metro#.U6hzCeg5DuQ'),
        Rule.new(%r{^/regions/massachusetts-apartments/?},       '/apartments/communities/boston-metro#.U6hz1Og5DuQ'),
        Rule.new(%r{^/regions/connecticut-apartments/?},         '/apartments/communities/new-york-city-metro#.U6h0Jeg5DuQ'),
        Rule.new(%r{^/regions/new-jersey-apartments/?},          'apartments/communities/new-york-city-metro#.U6h0Jeg5DuQ'),
        Rule.new(%r{^/regions/new-york-apartments/?},            '/apartments/communities/new-york-city-metro#.U6hzhOg5DuQ'),
        Rule.new(%r{^/regions/pennsylvania-apartments/?},        '/apartments/communities/philadelphia-metro#.U6hz7ug5DuQ'),
        Rule.new(%r{^/regions/virginia-apartments/?},            '/apartments/communities/washington-dc-metro#.U6h0Rug5DuQ'),
        Rule.new(%r{^/regions/bozzuto-management/?},             '/services/management'),
        Rule.new(%r{^/regions/bozzuto-homebuilding/?},           '/services/homebuilding'),
        Rule.new(%r{^/regions/bozzuto-construction/?},           '/services/construction'),
        Rule.new(%r{^/regions/bozzuto-land/?},                   '/services/land'),
        Rule.new(%r{^/regions/bozzuto-acquisitions/?},           '/services/acquisitions'),
        Rule.new(%r{^/regions/bozzuto-development/?},            '/services/development'),
        Rule.new(%r{^/regions/bozzuto-apartments/?},             '/apartments'),
        Rule.new(%r{^/regions/bethesda-apartments/?},            '/apartments/communities/washington-dc-metro/bethesda#.U6h4E-g5DuQ'),
        Rule.new(%r{^/regions/dc-metro-apartments/?},            '/apartments/communities/washington-dc-metro#.U6h4A-g5DuQ'),
        Rule.new(%r{^/regions/howard-county-townhomes/?},        '/new-homes/communities/howard-county#.U853s-hGwRw'),
        Rule.new(%r{^/regions/washington-dc-ne-se-apartments/?}, '/apartments/communities/washington-dc-metro#.U6h4lOg5DuQ'),
        Rule.new(%r{^/regions/dc-nw-apartments/?},               '/apartments/communities/washington-dc-metro/nw-washington-dc#.U6h4tug5DuQ'),
        Rule.new(%r{^/regions/annapolis-apartments/?},           '/apartments/communities/baltimore-annapolis-metro/annapolis#.U6h41Og5DuQ'),
        Rule.new(%r{^/regions/baltimore-apartments/?},           '/apartments/communities/baltimore-annapolis-metro/baltimore#.U6h44ug5DuQ'),
        Rule.new(%r{^/regions/bethesda-rockville-apartments/?},  '/apartments/communities/washington-dc-metro#.U6h4-ug5DuQ'),
        Rule.new(%r{^/regions/howard-county-md-apartments/?},    '/apartments/communities/baltimore-annapolis-metro/columbia-laurel#.U6h5Q-g5DuQ'),
        Rule.new(%r{^/regions/laurel-apartments/?},              '/apartments/communities/baltimore-annapolis-metro/columbia-laurel#.U6h5Q-g5DuQ'),
        Rule.new(%r{^/regions/alexandria-apartments/?},          '/apartments/communities/washington-dc-metro/alexandria#.U6h6Wug5DuQ'),
        Rule.new(%r{^/regions/arlington-apartments/?},           '/apartments/communities/washington-dc-metro/arlington#.U6h6e-g5DuQ'),
        Rule.new(%r{^/regions/fairfax-falls-church-apartments/?},'/apartments/communities/washington-dc-metro/northern-virginia#.U6h6iOg5DuQ'),
        Rule.new(%r{^/regions/boston-apartments/?},              '/apartments/communities/boston-metro#.U6h64ug5DuQ'),
        Rule.new(%r{^/regions/medford-apartments/?},             '/apartments/communities/boston-metro/medford#.U6h6_ug5DuQ'),
        Rule.new(%r{^/regions/boston-apartments/?},              '/apartments/communities/boston-metro#.U6h64ug5DuQ'),
        Rule.new(%r{^/regions/woburn-apartments/?},              '/apartments/communities/boston-metro/reading-woburn#.U6h7Hug5DuQ'),
        Rule.new(%r{^/regions/philadelphia-apartments/?},        '/apartments/communities/philadelphia-metro#.U6h7Lug5DuQ'),
        Rule.new(%r{^/regions/jersey-city-hoboken-apartments/?}, '/apartments/communities/new-york-city-metro/hoboken-jersey-city#.U6h7Rug5DuQ'),
        Rule.new(%r{^/regions/englewood-apartments/?},           '/apartments/communities/new-york-city-metro/englewood-fort-lee#.U6h7ZOg5DuQ'),
        Rule.new(%r{^/regions/new-york-city-apartments/?},       '/apartments/communities/new-york-city-metro/new-york-city'),
        Rule.new(%r{^/regions/white-plains-apartments/?},        '/apartments/communities/new-york-city-metro/white-plains#.U6h75eg5DuQ'),
        Rule.new(%r{^/regions/massapequa-apartments/?},          '/apartments/communities/new-york-city-metro#.U6h7Pug5DuQ'),
        Rule.new(%r{^/regions/new-haven-apartments/?},           '/apartments/communities/new-york-city-metro/new-haven#.U6h8Ieg5DuQ'),
        Rule.new(%r{^/regions/columbia-apartments/?},            '/apartments/communities/baltimore-annapolis-metro/columbia-laurel#.U6h5Q-g5DuQ'),
        Rule.new(%r{^/regions/rockville-apartments/?},           '/apartments/communities/washington-dc-metro/rockville#.U6h_Aeg5DuQ'),
        Rule.new(%r{^/regions/annapolis-homes/?},                '/new-homes/communities#.U853pehGwRw'),
        Rule.new(%r{^/regions/baltimore-area-homes/?},           '/new-homes/communities/baltimore#.U8532OhGwRw'),
        Rule.new(%r{^/regions/howard-county-homes/?},            '/new-homes/communities/howard-county#.U8535OhGwRw'),
        Rule.new(%r{^/regions/towson-area-homes/?},              '/new-homes/communities/towson#.U8537ehGwRw'),
        Rule.new(%r{^/regions/stamford-apartments/?},            '/apartments/communities/new-york-city-metro/stamford#.U6h_lug5DuQ'),
        Rule.new(%r{^/regions/washington-dc-apartments--2/?},    '/apartments/communities/washington-dc-metro#.U6h_uOg5DuQ'),
        Rule.new(%r{^/regions/boston-area-apartments/?},         '/apartments/communities/boston-metro#.U6h_xOg5DuQ'),
        Rule.new(%r{^/regions/annapolis-area-apartments/?},      '/apartments/communities/baltimore-annapolis-metro/annapolis#.U6iAEug5DuQ'),
        Rule.new(%r{^/regions/maryland-suburbs-apartments/?},    '/apartments/communities/baltimore-annapolis-metro#.U6iADug5DuQ'),
        Rule.new(%r{^/regions/new-york-area-apartments/?},       '/apartments/communities/new-york-city-metro#.U6iANOg5DuQ'),
        Rule.new(%r{^/regions/central-pennsylvania-apartments/?},'/apartments/communities/philadelphia-metro#.U6iAWug5DuQ'),
        Rule.new(%r{^/regions/northern-virginia-apartments/?},   '/apartments/communities/washington-dc-metro/northern-virginia#.U6iAbeg5DuQ'),
        Rule.new(%r{^/regions/philadelphia-apartments--2/?},     '/apartments/communities/philadelphia-metro#.U6iAWug5DuQ'),
        Rule.new(%r{^/regions/baltimore-city-apartments/?},      '/apartments/communities/baltimore-annapolis-metro/baltimore#.U6iAp-g5DuQ'),
        Rule.new(%r{^/regions/alexandria-va-apartments--2/?},    '/apartments/communities/washington-dc-metro/alexandria#.U6iAxOg5DuQ'),
        Rule.new(%r{^/regions/new-york-apartments--2/?},         '/apartments/communities/new-york-city-metro'),
        Rule.new(%r{^/regions/howard-county-apartments/?},       '/apartments/communities/baltimore-annapolis-metro/columbia-laurel#.U6iA6ug5DuQ'),
        Rule.new(%r{^/regions/baltimore-suburbs-apartments/?},   '/apartments/communities/baltimore-annapolis-metro#.U6iA5eg5DuQ'),
        Rule.new(%r{^/regions/northern-new-jersey-apartments/?}, '/apartments/communities/new-york-city-metro#.U6iBbug5DuQ'),
        Rule.new(%r{^/regions/dc-ne-apartments/?},               '/apartments/communities/washington-dc-metro/ne-washington-dc#.U6iBlOg5DuQ'),
        Rule.new(%r{^/regions/dc-se-apartments/?},               '/apartments/communities/washington-dc-metro/se-washington-dc#.U6iBn-g5DuQ'),
        Rule.new(%r{^/regions/virginia-suburbs-apartments/?},    '/apartments/communities/washington-dc-metro/northern-virginia#.U6iBseg5DuQ'),
        Rule.new(%r{^/regions/washington-suburbs-apartments/?},  '/apartments/communities/washington-dc-metro#.U6iBjug5DuQ'),
        Rule.new(%r{^/regions/pennsylvania-suburbs/?},           '/apartments/communities/washington-dc-metro#.U6iBjug5DuQ'),

        Rule.new(
          %r{^/regions/gaithersburg-germantown-frederick-apartments/?},
          '/apartments/communities/washington-dc-metro#.U6h4-ug5DuQ'
        ),

        Rule.new(
          %r{^/regions/germantown-apartments/?},
          '/apartments/communities/washington-dc-metro/marylanddc-region/germantown#.U6iBK-g5DuQ'
        ),

        Rule.new(
          %r{^/regions/herndon-and-reston-apartments/?},
          '/apartments/communities/washington-dc-metro/northern-virginia/reston#.U6iBU-g5DuQ'
        ),

        Rule.new(
          %r{^/regions/reston-apartments/?},
          '/apartments/communities/washington-dc-metro/northern-virginia/reston#.U6iAg-g5DuQ'
        ),

        Rule.new(
          %r{^om/regions/manassas-apartments/?},
          '/apartments/communities/washington-dc-metro/northern-virginia/manassas-bull-run#.U6h6m-g5DuQ'
        ),

        Rule.new(
          %r{^/regions/gaithersburg-apartments/?},
          '/apartments/communities/washington-dc-metro/marylanddc-region/kentlands-gaithersburg#.U6h_9-g5DuQ'
        ),

        Rule.new(
          %r{^/regions/north-bethesda-wheaton-apartments/?},
          '/apartments/communities/washington-dc-metro/marylanddc-region/wheaton-glenmont#.U6h5heg5DuQ'
        ),

        Rule.new(
          %r{^/regions/upper-marlboro-prince-frederick-apartments/?},
          '/apartments/communities/baltimore-annapolis-metro#.U6h6Eug5DuQ'
        ),

        Rule.new(
          %r{^/regions/ft-meade-arundel-mills-apartments/?},
          '/apartments/communities/baltimore-annapolis-metro/anne-arundel#.U6h6Q-g5DuQ'
        ),

        Rule.new(
          %r{^/regions/reston-herndon-centreville-apartments/?},
          '/apartments/communities/washington-dc-metro/northern-virginia#.U6h6aOg5DuQ'
        ),

        Rule.new(
          %r{^/regions/cedar-knolls-morristown-apartments/?},
          '/apartments/communities/new-york-city-metro#.U6h7Pug5DuQ'
        ),

        Rule.new(
          %r{^/regions/south-orange-irvington-maplewood-apartments/?},
          '/apartments/communities/new-york-city-metro#.U6h7Pug5DuQ'
        ),

        Rule.new(
          %r{^/regions/harbor-east-apartments/?},
          '/apartments/communities/baltimore-annapolis-metro/baltimore/harbor-east#.U6h0Zug5DuQ'
        ),

        Rule.new(
          %r{^/regions/owings-mills-apartments/?},
          '/apartments/communities/baltimore-annapolis-metro/owings-mills-reisterstown#.U6h36-g5DuQ'
        ),

        Rule.new(
          %r{.*},
          'http://www.bozzuto.com/apartments/communities/35-strathmore-court-at-white-flint',
          :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] =~ /strathmorecourtapts\.com$/ }
        ),

        Rule.new(
          %r{.*},
          'http://www.bozzuto.com/apartments/communities/213-timberlawn-crescent',
          :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] =~ /timberlawncrescent\.com$/ }
        )
      ]
    end

    private

    Rule = Struct.new :url_regex, :redirect_url, :condition do
      def initialize(*)
        super
        self.condition ||= nil
      end

      def components
        [url_regex, redirect_url, condition].compact
      end
    end
  end
end
