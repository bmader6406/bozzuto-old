module Bozzuto
  module HyLy
    ID = 'AXrxloE2b'

    PIDS = {
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
      thing.is_a?(Property) ? thing.hyly_id : PIDS[thing]
    end
  end
end
