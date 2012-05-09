node basenode {
  include ssh
}
node /^hyc\d{3}\.hostyourcreeper\.net$/ inherits basenode{
  include firewall
  include xen-tools
}
