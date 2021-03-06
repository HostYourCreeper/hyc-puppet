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
    package { 'nmap':
      ensure => latest,
    }
    package { 'htop':
      ensure => latest,
    }
    package { 'pwgen':
      ensure => latest,
    }
    package { 'xen-hypervisor-4.0-amd64':
      ensure => latest,
    }
    package { 'xen-tools':
      ensure => latest,
      require => Package['xen-hypervisor-4.0-amd64'],
    }
    file {'/etc/xen/xend-config.sxp':
      ensure => file,
      mode   => 0644,
      source => 'puppet:///modules/xen-tools/xend-config.sxp',
      require => Package['xen-hypervisor-4.0-amd64'],
    }
    file {'/etc/xen-tools/xen-tools.conf':
      ensure  => file,
      mode    => 0644,
      source  => 'puppet:///modules/xen-tools/xen-tools.conf',
      require => Package['xen-tools'],
    }
    file {'/etc/xen-tools/xm.tmpl':
      ensure  => file,
      mode    => 0644,
      source  => 'puppet:///modules/xen-tools/xm.tmpl',
      require => package['xen-tools'],
    }
    file {'/etc/xen-tools/nginx.d':
      ensure  => directory,
      mode    => 0644,
      source  => 'puppet:///modules/xen-tools/nginx.d',
      recurse => true,
    }
    file {'/etc/xen-tools/minecraft.d':
      ensure  => directory,
      mode    => 0644,
      source  => 'puppet:///modules/xen-tools/minecraft.d',
      recurse => true,
    }
    file { '/etc/xen-tools/minecraft.d/murmur-static_x86':
      ensure  => directory,
      purge   => false,
      recurse => true,
      source  => 'puppet:///modules/murmur/murmur-static_x86/',
      mode    => 0644,
      require => File['/etc/xen-tools/minecraft.d'],
    }
    file { '/etc/xen-tools/minecraft.d/murmur':
      ensure  => file,
      source  => 'puppet:///modules/murmur/murmur',
      mode    => 0644,
      require => File['/etc/xen-tools/minecraft.d'],
    }
    file { '/etc/xen-tools/minecraft.d/minecraft':
      ensure  => file,
      source  => 'puppet:///modules/minecraft/minecraft',
      mode    => 0644,
      require => File['/etc/xen-tools/minecraft.d'],
    }
    file { '/etc/xen-tools/minecraft.d/minecraft.conf':
      ensure  => file,
      source  => 'puppet:///modules/minecraft/minecraft.conf',
      mode    => 0644,
      require => File['/etc/xen-tools/minecraft.d'],
    }
    file {'/etc/xen-tools/role.d':
      ensure  => directory,
      mode    => 0755,
      source  => 'puppet:///modules/xen-tools/role.d',
      recurse => true,
      purge   => false,
    }

    file {'/etc/xen-tools/api.d':
      ensure  => directory,
      mode    => 0644,
    }

    file {'/etc/xen-tools/api.d/api.conf':
      ensure => file,
      mode   => 0644,
      source => 'puppet:///modules/minecraft/api.conf',
      owner  => root,
      group  => root,
      require => File['/etc/xen-tools/api.d']
    }

    file { '/etc/xen-tools/api.d/api':
      ensure => directory,
      mode   => 0644,
      recurse => true,
      owner  => root,
      group  => root,
      source => 'puppet:///modules/minecraft/hyc-vm',
      ignore => '.git',
      require => File['/etc/xen-tools/api.d']
    }
}
