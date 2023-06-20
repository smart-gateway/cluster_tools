require 'facter'
# Simulated Output
# +-------------------------------------+----------------+
# |              Input                  |     Output     |
# +-------------------------------------+----------------+
# |          puppet.edge.lan            |     shared     |
# |      puppet.niwc.edge.lan           |      niwc      |
# | node01.something.lenovo.edge.lan    |     lenovo     |
# |              fresh-01.maas          |     shared     |
# |          mgmt.ido.edge.lan          |      ido       |
# |            mgmt.edge.lan            |     shared     |
# |  node04.x.t.y.z.f.q.niwc.edge.lan   |      niwc      |
# +-------------------------------------+----------------+
#
Facter.add('subproject') do
  setcode do
    if Facter.value(:networking)['fqdn'].split('.').count >= 4
      subproject = Facter.value(:networking)['fqdn'].split('.')[0..-3].last
    else
      subproject = 'shared'
    end
    subproject
  end
end
