# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::install
class cluster_tools::install {
  # Setup the .profile skeleton file
  file { '/usr/local/bin/netcheck':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/cluster_tools/tools/netcheck.py",
  }
}
