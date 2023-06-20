require 'facter'

Facter.add('snoopy_ini_exists') do
    setcode do
        File.exist?('/etc/snoopy.ini')
    end
end