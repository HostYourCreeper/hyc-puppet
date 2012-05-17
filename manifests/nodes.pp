import "common"
import "munin"

$munin_cidr_allow = '188.165.47.98/32'

node basenode {
  include ssh
}
node /^hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include firewall
  include xen-tools
  include hyc-api
  include ntp
  include monit
  monit::service { "api": }
  monit::service { "puppet-agent": }
  monit::service { "ntp": }
  include munin::client
}
