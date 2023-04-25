# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::service
class cluster_tools::service {

  $puppet_exporter_desired_state = $::cluster_tools::puppet_exporter_ensure ? {
    'absent'      => 'disabled',
    'removed'     => 'disabled',
    'uninstalled' => 'disabled',
    default       => 'running',
  }

  file { '/etc/systemd/system/puppet-agent-exporter.service':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => "[Unit]
Description=Puppet Agent Exporter

[Service]
Type=simple
ExecStart=/usr/local/bin/puppet-agent-exporter
Restart=always

[Install]
WantedBy=multi-user.target",
    notify  => Service['puppet-agent-exporter'],
  }

  service { 'puppet-agent-exporter':
    ensure => 'running',
    enable => true,
    require => File['/etc/systemd/system/puppet-agent-exporter.service'],
  }

}
