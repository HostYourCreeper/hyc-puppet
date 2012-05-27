class puppet {
    package { 'puppet':
      ensure => latest,
    }
    package { 'augeas-tools':
      ensure => latest,
      require => Package['puppet'],
    }
    package { 'libaugeas-ruby':
      ensure => latest,
      require => Package['augeas-tools'],
    }
    augeas{"puppet.default" :
      context => "/etc/default/puppet",
      changes => "set START no",
      require => Package['augeas-tools'],
    }
    service { 'puppet':
      ensure          => running,
      hasrestart      => true,
      require         => Augeas['puppet.default'],
    }
}