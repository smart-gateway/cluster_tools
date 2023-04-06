# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::config
class cluster_tools::config {

  # If the host is joined to the realm configure access rules
  if $facts['host_realm'] {
    # Host is joined to a realm, configure access
    $group_identifier = $facts['project_id']
    if $group_identifier and !($group_identifier == "" or $group_identifier == "unknown" ) {
      notice("${::hostname}: identifier = ${group_identifier}")
      # Override to all users on management hosts
      $identifier_value = $facts['mgmt_host'] ? {
        false   => $group_identifier,
        default => $facts['project_id_effective'],
      }

      file { '/etc/security/access.conf':
        ensure  => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        content => epp('cluster_tools/access/access.epp', {
          'group_identifier' => $identifier_value,
        }),
      }

      -> file_line { 'enable /etc/security/access.conf in /etc/pam.d/common-account':
        ensure  => present,
        path    => '/etc/pam.d/common-account',
        line    => 'account  required       pam_access.so',
        match   => '^account\s+required\s+pam_access\.so',
        replace => false,
      }
    } else {
      warning("${::hostname}: Unknown project_id value = '${facts['project_id']}'")
    }

  } else {
    # Host is not joined to a realm, just notify the server logs
    warning("${::hostname}: Host is not joined to a realm")
  }

}
