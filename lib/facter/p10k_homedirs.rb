require 'facter'

Facter.add('p10k_homedirs') do
  setcode do
    homedirs = []
    Dir.glob('/home/*').each do |homedir|
      if File.exist?(File.join(homedir, '.p10k.zsh'))
        homedirs << homedir
      end
    end
    homedirs
  end
end
