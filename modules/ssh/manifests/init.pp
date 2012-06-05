class ssh{
  package { "openssh-server":
    ensure => latest,
  }
  service { 'ssh':
    ensure          => running,
    hasrestart      => true,
  }
}
