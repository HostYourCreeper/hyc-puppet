node basenode {
  include ssh
}
node /^hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include firewall
  include xen-tools
  include hyc-api
  include monit
  monit::service { "api": }
  monit::service { "puppet-agent": }
  monit::service { "ntp": }
}
