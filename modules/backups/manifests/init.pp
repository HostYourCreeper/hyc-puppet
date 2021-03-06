class backups {
  tidy { "/home/minecraft/world_backups":
    age     => "2w",
    recurse => true,
    matches => [ "*.tar.bz2", "*.tar.gz" ],
    rmdirs  => false,
  }

  tidy { "/home/minecraft/server_backups":
    age     => "2w",
    recurse => true,
    matches => [ "*" ],
    rmdirs  => true,
  }

  tidy { "/home/minecraft/minecraft/logs":
    age     => "1w",
    recurse => true,
    matches => [ "*" ],
    rmdirs  => false,
  }

}
