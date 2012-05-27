class puppet {
    package { 'puppet':
      ensure => latest,
    }
    package { 'augeas-tools':
      ensure => latest,
      require => Package['puppet'],
    }
    augeas{"puppet.default" :
      context => "/etc/default/puppet",
      changes => "set START yes",
      require => Package['augeas-tools'],
    }
    service { 'puppet':
      ensure          => running,
      hasrestart      => true,
      require         => Augeas['puppet.default'],
    }
}