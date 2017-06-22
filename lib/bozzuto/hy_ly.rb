require 'csv'

module Bozzuto
  module HyLy
    mattr_accessor :pid_file
    self.pid_file = Rails.root.join('db', 'seeds', 'hyly_pids.csv')

    PRIMARY_ID   = 'AXrxloE2b'
    ALT_ID       = 'pXCkf054i'
    HOMES_ID     = 'jPeZi42q1'
    BUZZ_ID      = 'RDz6g84VF'
    PRIMARY_HOST = 'app.hy.ly'
    HOMES_HOST   = 'my.hy.ly/mktg'
    PIDS         = {
      'Bozzuto'                      => '',
      'Bozzuto Management Company'   => '1452068536020681077',
      'Bozzuto Homes'                => '1453516885273668017',
      'Bozzuto Broker'               => '1450795011166496171',
      'Bozzuto Construction Company' => '1450337019022333403',
      'Bozzuto Sweepstakes'          => '1446096060741173278',
      'Required E-mails'             => '1450258884076377608',
      'Bozzuto Buzz'                 => '1446094412836619922',
      'Under Construction'           => '1471996750322917107',
      'SEO Consult Schedule'         => '1478693902929857747',
      'Bozzuto Tom Blog'             => '1468001471740508313',
      'Talent Acquisition'           => '1459695515386765413',
      'HR & Training'                => '1456761470759358596'
    }

    def self.pid_for(thing)
      thing.respond_to?(:hyly_id) ? thing.hyly_id : PIDS[thing]
    end

    def self.host_for(thing)
      thing.is_a?(HomeCommunity) ? HOMES_HOST : PRIMARY_HOST
    end

    def self.seed_pids
      CSV.foreach(pid_file, headers: true) do |row|
        ApartmentCommunity.find_by_title(row['Property Name']).tap do |community|
          unless community.nil? || community.hyly_id.present?
            community.update_attributes(:hyly_id => row['PID'])
          end
        end
      end
    end
  end
end
