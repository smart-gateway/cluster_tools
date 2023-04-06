# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::config
class cluster_tools::config {

  notice("===DEBUG=== pp_project = ${::cluster_tools::pp_project} | pp_cluster = ${::cluster_tools::pp_cluster}")
  # If the host is joined to the realm configure access rules
  if $facts['host_realm'] {

    $certname = $facts['networking']['fqdn']
    if $::cluster_tools::pp_project != "unknown" {
      # Check if this is a subproject host managed by the shared puppet
      $subproject = $facts['subproject']

      # Set the project_id - on shared MGMT host(s) we allow access to all users
      $project_id = $subproject ? {
        'niwc'   => '064',
        'lenovo' => '065',
        'wsr'    => '066',
        'ido'    => '067',
        'shared' => $facts['mgmt_host'] ? {
          true  => 'all',
          false => 'shared',
        },
        default  => 'unknown',
      }

      # Create the access.conf file to restrict access to specific groups - puppetservers don't allow anyone
      file { '/etc/security/access.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp('cluster_tools/access/access.epp', {
          'group_identifier' => $::hostname ? {
            'puppetserver' => 'puppet-admins-${project_id}',
            'puppet'       => 'puppet-admins-shared',
            default        => "users-${project_id}",
          },
        }),
      }

      # Ensure that the config file is being used for access
      -> file_line { 'enable /etc/security/access.conf in /etc/pam.d/common-account':
        ensure  => present,
        path    => '/etc/pam.d/common-account',
        line    => 'account  required       pam_access.so',
        match   => '^account\s+required\s+pam_access\.so',
        replace => false,
      }

      # Make special adjustments on MGMT hosts to restrict users

    } else {
      warning("${::hostname}: Unknown project_id value = '${::cluster_tools::pp_project}'")
    }

  } else {
    # Host is not joined to a realm, just notify the server logs
    warning("${::hostname}: Host is not joined to a realm")
  }

}
