class puppet::onetime inherits puppet{
  augeas{"puppet.default" :
    context => "/files/etc/default/puppet",
    changes => "set START false",
    require => Package['augeas-tools'],
  }
  service { 'puppet':
    ensure          => running,
    hasrestart      => false,
    require         => Augeas['puppet.default'],
  }
  cron { 'puppet-agent':
    command => "/usr/bin/puppet agent --onetime",
    user => root,
    hour => '*/3',
  }
}