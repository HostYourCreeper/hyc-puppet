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
  include puppet::daemon
  include monit
  monit::service { "api": }
  monit::service { "puppet-agent": }
  monit::service { "ntp": }
  include munin::client
  munin::plugin { df: }
  munin::plugin { df_abs: }
  munin::plugin { netstat: }
  munin::plugin { processes: }
  munin::plugin { cpu: }
  munin::plugin { load: }
  munin::plugin { memory: }
  munin::plugin { swap: }
}
node /^server\d{3}\.hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include ntp
  include murmur
  include backups
  #include puppet::onetime
  include monit
  include minecraft
  #monit::service { "puppet-agent": }
  monit::service { "ntp": }
  #include munin::client
  #munin::plugin { df: }
  #munin::plugin { df_abs: }
  #munin::plugin { netstat: }
  #munin::plugin { processes: }
  #munin::plugin { cpu: }
  #munin::plugin { load: }
  #munin::plugin { memory: }
  #munin::plugin { swap: }
}
