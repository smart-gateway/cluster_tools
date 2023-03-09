# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::install
class cluster_tools::install {
  # Setup the .profile skeleton file
  $netcheck_desired_state = $::cluster_tools::netcheck_ensure ? {
    'absent'      => 'absent',
    'removed'     => 'absent',
    'uninstalled' => 'absent',
    default       => 'file',
  }
  file { '/usr/local/bin/netcheck':
    ensure => $netcheck_desired_state,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/cluster_tools/tools/netcheck.py",
  }
}
