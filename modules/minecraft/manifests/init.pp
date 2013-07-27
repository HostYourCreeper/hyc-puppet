class minecraft {
  #package { 'sun-java6-jre':
  #  ensure => latest,
  #}

  file {'/etc/apt/sources.list.d/webupd8team-java.list':
    ensure => file,
    mode   => 0644,
    source => 'puppet:///modules/minecraft/java.list',
    owner  => root,
    group  => root,
  }

  exec {'apt-key':
    command =>  '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886',
    require => File['/etc/apt/sources.list.d/webupd8team-java.list']
  }
  exec {'apt update':
    command => '/usr/bin/apt-get update',
    require => Exec['apt-key']
  }

  exec {'license':
    command => '/bin/echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
    require => Exec['apt update']
  }
  package { 'oracle-java7-installer':
    ensure => latest,
    require => Exec['license']
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
    mode   => 0644,
    recurse => true,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/minecraft/hyc-vm',
    ignore => '.git',
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
    source => 'puppet:///modules/minecraft/api.conf',
    owner  => root,
    group  => root,
    notify => Service['apache2']
  }

  file {'/etc/cron.d/minecraft':
    ensure => file,
    mode   => 0644,
    source => 'puppet:///modules/minecraft/cron',
    owner  => root,
    group  => root
  }
}
