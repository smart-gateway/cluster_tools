# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::bash::custom_ps1
class cluster_tools::bash::custom_ps1(
  String  $cluster_name,
  String  $project_name,
  Boolean $user_onetime_overwrite = false,
  Boolean $cluster_hide_shared = true,
  Array[String] $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
) {

  $cluster_ps1 = ( ( $project_name == 'shared' ) and ( $cluster_hide_shared ) ) ? {
    false   => "-${project_name}-${cluster_name}",
    default => "-${cluster_name}"
  }

  $cluster_info = @("END")
    # HEADER:  /etc/.profile.d/02-cluster-info.sh
    # HEADER:
    # HEADER:  This file was autogenerated by Puppet.
    # HEADER:  Any manual changes to this file will be overwritten.
    
    export CLUSTER_NAME="${cluster_name}"
    export CLUSTER_PROJECT="${project_name}"
    export CLUSTER_PS1="${cluster_ps1}"
    | - END

  # Set the .profile.d file with the ENV variables
  file { '/etc/profile.d/02-cluster-info.sh':
    ensure  => file,
    content => $cluster_info,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # Setup the .bashrc skeleton file ... for now just use the ENV variables instead of the real values
  file { '/etc/skel/.bashrc':
    ensure  => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => epp('cluster_tools/bashrc.epp', {
      'cluster_ps1' => "\${CLUSTER_PS1}"
    }),
  }

  # Setup the .profile skeleton file
  file { '/etc/skel/.profile':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/cluster_tools/etc/skel/.profile",
  }

  # Copy to the existing users only when the file is overwritten by puppet
  if $user_onetime_overwrite {
    exec { 'push updated .bashrc and .profile to the existing users':
      command     => '/usr/bin/find /home -type d -exec /usr/bin/cp /etc/skel/.bashrc {} \; -exec /usr/bin/cp /etc/skel/.profile {} \;',
      path        => $cluster_tools::bash::custom_ps1::path,
      subscribe   => [
        File['/etc/skel/.bashrc'],
        File['/etc/skel/.profile'],
      ],
      refreshonly => true,
    }
  }
}
