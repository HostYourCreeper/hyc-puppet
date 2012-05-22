class murmur {
  file { '/home/minecraft/murmur':
    ensure  => directory,
    purge   => false,
    owner   => 'minecraft',
    group   => 'minecraft',
    mode    => 644,
  }

  file { '/home/minecraft/murmur/murmur.x86':
    source  => 'puppet:///modules/murmur/murmur-static_x86/murmur.x86',
    ensure  => file,
    owner   => 'minecraft',
    group   => 'minecraft',
    mode    => 755,
    require => File['/home/minecraft/murmur'],
  }

  file { '/home/minecraft/murmur/murmur.ini':
    source  => 'puppet:///modules/murmur/murmur-static_x86/murmur.ini',
    ensure  => file,
    owner   => 'minecraft',
    group   => 'minecraft',
    mode    => 644,
    replace => false,
    backup  => '.bak',
    require => File['/home/minecraft/murmur'],
  }  

  file { '/etc/init.d/murmur':
    source  => 'puppet:///modules/murmur/murmur',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 755,
    require => File['/home/minecraft/murmur/murmur.x86'],
  }

  service { 'murmur':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    path       => "/etc/init.d/murmur",
    require    => File['/etc/init.d/murmur'],
  }
}
