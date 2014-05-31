import "common"

node basenode {
  include ssh
}
node /^hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include firewall
  include xen-tools
  include ntp
  include puppet::daemon
  include puppet::node
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
  include backups
  include puppet
  include puppet::onetime
  include minecraft
  include nagios::nrpe-vm
}
