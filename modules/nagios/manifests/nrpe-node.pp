class nagios::nrpe-node inherits nagios::nrpe {

  file {'/etc/nagios/nrpe_local.cfg':
      ensure => file,
      mode   => 0644,
      source => 'puppet:///modules/nagios/nrpe_local.cfg',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
  }
}
