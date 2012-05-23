class logrotate {
  package { 'logrotate':
    ensure => latest,
  }

  file { '/etc/logrotate.d/minecraft':
    ensure => file,
    source => 'puppet:///modules/logrotate/minecraft',
    owner  => root,
    group  => root,
    mode   => 644,
    require => Package['logrotate'],
  }
}
