require 'facter'

Facter.add('mgmt_host') do
  setcode do
    hostname = Facter.value(:hostname)
    if hostname.start_with?('mgmt')
      true
    else
      false
    end
  end
end
