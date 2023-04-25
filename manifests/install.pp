# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::install
class cluster_tools::install {
  # map ensure values to valid file ensure values
  $netcheck_desired_state = $::cluster_tools::netcheck_ensure ? {
    'absent'      => 'absent',
    'removed'     => 'absent',
    'uninstalled' => 'absent',
    default       => 'file',
  }
  $puppet_exporter_desired_state = $::cluster_tools::puppet_exporter_ensure ? {
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
  file { '/usr/local/bin/puppet-agent-exporter':
    ensure => puppet_exporter_desired_state,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cluster_tools/tools/puppet-agent-exporter',
  }
}
