# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::config
class cluster_tools::config {

  # If the host is joined to the realm configure access rules
  if $facts['host_realm'] {

    # map the project name to a project_id
    $group_identifier = $::cluster_tools::pp_project ? {
      'shared' => 'shared',
      'niwc'   => '064',
      'lenovo' => '065',
      'wsr'    => '066',
      'ido'    => '067',
      default  => 'unknown',
    }

    if $group_identifier != "unknown" {
      notice("${::hostname}: project_id = ${group_identifier}")
      # Override to all users on management hosts
      $identifier_value = $facts['mgmt_host'] ? {
        false   => $group_identifier,
        default => $facts['subproject'],
      }

      file { '/etc/security/access.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
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
