class nagios-nrpe {

  file { "/etc/nagios-plugins/config":
    mode    => "755",
    require => Package["nagios-plugins"],
    source  => "puppet:///modules/nagios/client-plugins/",
    purge   => false,
    recurse => true,
  }

  package {
    "nagios-nrpe-server": ensure => present;
    "nagios-plugins": ensure => present;
  }

  service { "nagios-nrpe-server":
    ensure    => running,
    enable    => true,
    pattern   => "nrpe",
    subscribe => File["/etc/nagios/nrpe_local.cfg"];
  }

  file {'/etc/nagios/nrpe_local.cfg':
      ensure => file,
      mode   => 0644,
      source => 'puppet:///modules/nagios/nrpe_local.cfg',
      require => Package['nagios-nrpe-server'],
  }
}
