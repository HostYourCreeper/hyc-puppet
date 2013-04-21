import "common"

node basenode {
  include ssh
}
node /^hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include firewall
  include xen-tools
  include hyc-api
  include ntp
  include puppet::daemon
  include puppet::node
  include monit
  monit::service { "api": }
  monit::service { "puppet-agent": }
  monit::service { "ntp": }
  include nagios::nrpe-node
  include nagios::nsca
}

node /^nginx.hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include ntp
  include puppet::daemon
} 

node /^server\d{3}\.hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include ntp
  include murmur
  #include backups
  include puppet
  include puppet::onetime
  include monit
  include minecraft
  include nagios::nrpe-vm
  monit::service { "ntp": }
}
