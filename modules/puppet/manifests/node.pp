class puppet::node {
  file { '/root/update.sh':
    ensure  => file,
    source  => 'puppet:///modules/puppet/update.sh',
    mode    => 0755,
  }
  file { '/root/backups.sh':
    ensure  => file,
    source  => 'puppet:///modules/puppet/backups.sh',
    mode    => 0755,
  }
  cron { 'puppet-update':
    ensure => present,
    command => "bash /root/update.sh >/dev/null",
    user => root,
    hour => '*/6',
    minute => 0,
    require => File['/root/update.sh'],
  }
#  cron { 'puppet-backups':
#    ensure => present,
#    command => "bash /root/backups.sh >/dev/null 2>&1",
#    user => root,
#    hour => 6,
#    minute => 30,
#    require => File['/root/backups.sh'],
#  }
  file { '/root/.ssh/config':
    ensure => file,
    source => 'puppet:///modules/puppet/config',
    mode   => 0644,
  }
}
