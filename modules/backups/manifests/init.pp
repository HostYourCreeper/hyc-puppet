class backups {
  tidy { "/home/minecraft/world_backups":
    age     => "2w",
    recurse => true,
    matches => [ "*.tar.bz2", "*.tar.gz" ],
    rmdirs  => false,
  }
}
