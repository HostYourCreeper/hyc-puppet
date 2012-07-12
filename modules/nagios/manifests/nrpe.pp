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

  service { "nagios-nrpe-server":
    ensure    => running,
    enable    => true,
    pattern   => "nrpe",
  }
}
