class puppet::daemon inherits puppet {
  augeas{"puppet.default" :
    context => "/files/etc/default/puppet",
    changes => "set START yes",
    require => Package['augeas-tools'],
  }
  service { 'puppet':
    ensure          => running,
    hasrestart      => true,
    require         => Augeas['puppet.default'],
  }
}