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
