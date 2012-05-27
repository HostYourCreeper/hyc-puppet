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
}