class nagios {
  package { 'nagios3':
    ensure => latest,
  }
  package { 'nagios-nrpe-plugin':
    ensure => latest,
  }
  service { 'nagios3':
    ensure => running,
    enable => true,
    require => Package['nagios3'],
  }
}
