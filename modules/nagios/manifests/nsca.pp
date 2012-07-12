class nagios::nsca inherits nagios {
  package { 'nsca':
    ensure => latest,
  }
  service { 'nsca':
    ensure => stopped,
    enable => false,
  }
  augeas{"send_nsca.cfg" :
    context => "/files/etc/send_nsca.cfg",
    changes => [
      "set password lovehyc",
      "set encryption_method 1",
    ],
    require => Package['nsca'],
  }
  file { '/etc/nagios3/commands.cfg':
    ensure => file,
    source => 'puppet:///modules/nagios/commands.cfg',
    mode   => 0644,
    require => Package['nagios3'],
  }
  file { '/usr/lib/nagios/plugins/submit_check_result':
    ensure => file,
    source => 'puppet:///modules/nagios/submit_check_result',
    mode   => 0755,
    require => Package['nagios3'],
  }
  file { '/usr/lib/nagios/plugins/submit_check_result_host':
    ensure => file,
    source => 'puppet:///modules/nagios/submit_check_result_host',
    mode   => 0755,
    require => Package['nagios3'],
  } 
  augeas{"nagios.cfg" :
    context => "/files/etc/nagios3/nagios.cfg",
    changes => [
      "set enable_notifications 0",
      "set obsess_over_services 1",
      "set ocsp_command submit_check_result",
      "set obsess_over_hosts 1",
      "set ochp_command submit_check_result_host",
    ],
    require => Package['nsca'],
    notify => Service['nagios3'],
  }
  file { '/etc/nagios3/conf.d/vms.cfg':
    ensure => file,
    mode   => 0644,
    source => 'puppet:///modules/nagios/vms.cfg',
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
  file { '/etc/nagios3/conf.d/localhost_nagios2.cfg':
    ensure => absent,
    require => Package['nagios3'],
  }
  file { '/etc/nagios3/conf.d/hostgroups_nagios2.cfg':
    ensure => file,
    require => Package['nagios3'],
    mode => 0644,
    source => 'puppet:///modules/nagios/hostgroups_nagios2.cfg',
    notify => Service['nagios3'],
  }
}
