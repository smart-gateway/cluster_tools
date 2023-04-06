require 'facter'

Facter.add('host_realm') do
  setcode do
    realm = nil
    output = Facter::Util::Resolution.exec('realm list')
    if output =~ /realm-name:\s+(.+)/
      realm = $1
      realm = realm.downcase if realm
    end
    realm
  end
end
