# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools
class cluster_tools(
  Array[String] $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
  String        $netcheck_ensure = 'present',
) {

  # Ensure class declares subordinate classes
  contain cluster_tools::install
  contain cluster_tools::config
  contain cluster_tools::service

  # Order operations
  anchor { '::cluster_tools::begin': }
  -> Class['::cluster_tools::install']
  -> Class['::cluster_tools::config']
  -> Class['::cluster_tools::service']
  -> anchor { '::cluster_tools::end': }

}
