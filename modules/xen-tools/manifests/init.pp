# Class: xen-tools
#
# This module manages xen-tools
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
class xen-tools {
    package { 'xen-hypervisor-4.0-amd64':
      ensure => latest,
    }
    package { 'xen-tools':
      ensure => latest,
      require => Package['xen-hypervisor-4.0-amd64'],
    }
    file {'/etc/xen/xend-config.xsp':
      ensure => directory,
      mode   => 0644,
      require => Package['xen-hypervisor-4.0-amd64'],
    }
    file {'/etc/xen-tools/xen-tools.conf':
      ensure  => file,
      mode    => 0644,
      source  => 'puppet:///xen-tools/xen-tools.conf',
      require => Package['xen-tools'],
    }
    file {'/etc/xen-tools/nginx.d':
      ensure  => directory,
      mode    => 0644,
      source  => 'puppet:///xen-tools/nginx.d',
      recurse => true,
      require => File['/etc/xen-tools/xen-tools.conf'],
    }
    file {'/etc/xen-tools/minecraft.d':
      ensure  => directory,
      mode    => 0644,
      source  => 'puppet:///xen-tools/minecraft.d',
      recurse => true,
      require => File['/etc/xen-tools/xen-tools.conf'],
    }
    file {'/etc/xen-tools/role.d':
      ensure  => directory,
      mode    => 0644,
      source  => 'puppet:///xen-tools/role.d',
      recurse => true,
      purge   => false,
      require => File['/etc/xen-tools/xen-tools.conf'],
    }
}
