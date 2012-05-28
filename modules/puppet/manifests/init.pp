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
}