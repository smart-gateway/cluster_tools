Facter.add(:disabled_modules) do
    confine kernel: 'Linux'
  
    setcode do
      files_dir = '/opt/puppet-agent/controlled'
      files = Dir.glob("#{files_dir}/*.disabled")
  
      disabled_modules = {}
      files.each do |file|
        filename = File.basename(file, '.disabled')
        fact_name = "#{filename}_disabled"
        disabled_modules[fact_name] = true
      end
  
      disabled_modules
    end
  end
  