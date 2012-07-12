class nagios::nrpe-vm inherits nagios::nrpe {

  file {'/etc/nagios/nrpe_local.cfg':
      ensure => file,
      mode   => 0644,
      content => template('nagios/nrpe_local.cfg.erb'),
      require => Package["nagios-nrpe-server"],
      notify  => Service["nagios-nrpe-server"],
  }
}
