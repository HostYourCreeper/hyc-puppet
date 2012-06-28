class puppet::node {
  file { '/root/update.sh':
    ensure  => file,
    source  => 'puppet:///modules/puppet/update.sh',
    mode    => 0755,
  }
  cron { 'puppet-update':
    ensure => present,
    command => "/root/update.sh",
    user => root,
    hour => '*/6',
    minute => 0,
    require => File['/root/update.sh'],
  }
  file { '/root/.ssh/config':
    ensure => file,
    source => 'puppet:///modules/puppet/config',
    mode   => 0644,
  }
}
