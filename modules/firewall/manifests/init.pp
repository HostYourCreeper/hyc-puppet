# Class: firewall
#
# This module manages firewall
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class firewall {
    file {'/opt/firewall':
      ensure => directory,
      mode   => 0644,
    }
    file {'/opt/firewall/vm':
      ensure  => directory,
      mode    => 0644,
      purge   => false,
      require => File['/opt/firewall'],
    }
    file {'firewall.sh':
      path    => '/opt/firewall/firewall.sh',
      ensure  => present,
      mode    => 0755,
      source  => 'puppet:///modules/firewall/firewall.sh',
      require => File['/opt/firewall'],
    }
    exec { 'bash firewall.sh restart':
      cwd        => '/opt/firewall',
      path       => ["/bin", "sbin", "/usr/bin", "/usr/sbin"],
      subscribe  => File['firewall.sh'],
      refreshonly => true,
    }
}
