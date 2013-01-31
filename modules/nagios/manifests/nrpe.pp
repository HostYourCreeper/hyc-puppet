class nagios::nrpe {

#  file { "/etc/nagios-plugins/config":
#    mode    => "755",
#    require => Package["nagios-plugins"],
#    source  => "puppet:///modules/nagios/client-plugins/",
#    purge   => false,
#    recurse => true,
#  }

  package { "nagios-nrpe-server": 
    ensure => latest,
  }
  package { "nagios-plugins": 
    ensure => latest,
  }
  package { "libnagios-plugin-perl":
    ensure => latest,
  }

  service { "nagios-nrpe-server":
    ensure    => running,
    enable    => true,
    pattern   => "nrpe",
  }

  file { "/usr/lib/nagios/plugins/check_mem.pl":
    ensure  => file,
    require => Package['libnagios-plugin-perl'],
    mode    => "755",
    source  => "puppet:///modules/nagios/check_mem.pl",
    notify  => Service['nagios-nrpe-server'],
  }
}
