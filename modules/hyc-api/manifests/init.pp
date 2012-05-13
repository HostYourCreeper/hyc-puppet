# Class: hyc-api
#
# This module manages hyc-api
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
class hyc-api {
    file {'/opt/api':
      ensure => directory,
      mode   => 0644,
    }
    file {'server.js':
      path    => '/opt/api/server.js',
      ensure  => present,
      mode    => 0644,
      source  => 'puppet:///hyc-api/server.js',
      require => File['/opt/api'],
    }
    file {'/etc/init.d/api':
      ensure  => present,
      mode    => 0755,
      source  => 'puppet:///hyc-api/api.init',
      require => File['/opt/api'],
    }
    file {'create_image.sh':
      path    => '/opt/api/create_image.sh',
      ensure  => present,
      mode    => 0755,
      source  => 'puppet:///hyc-api/create_image.sh',
      require => File['/opt/api'],
    } 
}
