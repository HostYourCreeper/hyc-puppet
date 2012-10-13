class minecraft {
  package { 'sun-java6-jre':
    ensure => latest,
  }

  file {'/etc/init.d/minecraft':
    ensure => file,
    mode   => 0755,
    source => 'puppet:///modules/minecraft/minecraft',
    owner  => root,
    group  => root,
  }

  file {'/etc/minecraft.conf':
    ensure => file,
    mode   => 0644,
    source => 'puppet:///modules/minecraft/minecraft.conf',
    owner  => root,
    group  => root,
  }
  
  file { '/home/minecraft':
    ensure => directory,
    mode   => 0644,
    owner  => minecraft,
    group  => minecraft,
    purge  => false,
  }
  
  file { '/home/minecraft/minecraft':
    ensure => directory,
    mode   => 0644,
    owner  => minecraft,
    group  => minecraft,
    purge  => false,
    require => File['/home/minecraft'],
  }
  
  file { '/home/minecraft/server_backups':
    ensure => directory,
    mode   => 0644,
    owner  => minecraft,
    group  => minecraft,
    purge  => false,
    require => File['/home/minecraft'],
  }
  
  file { '/home/minecraft/world_backups':
    ensure => directory,
    mode   => 0644,
    owner  => minecraft,
    group  => minecraft,
    purge  => false,
    require => File['/home/minecraft'],
  }

  file { '/home/minecraft/worldstorage':
    ensure => directory,
    mode   => 0644,
    owner  => minecraft,
    group  => minecraft,
    purge  => false,
    require => File['/home/minecraft'],
  }

  file { '/var/www/api':
    ensure => directory,
    mode   => 0755,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/minecraft/hyc-vm/',
  }

  service { "apache2":
    ensure    => running,
    enable    => true,
    pattern   => "apache2",
    hasrestart => true,
    hasstatus => true,
  }

  file {'/etc/apache2/conf.d/api.conf':
    ensure => file,
    mode   => 0644,
    recurse => true,
    source => 'puppet:///modules/minecraft/api.conf',
    owner  => root,
    group  => root,
    notify => Service['apache2']
  }
}
