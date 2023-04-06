Facter.add('project_id_effective') do
  setcode do
    hostname = Facter.value(:hostname)
    project_id = Facter.value(:pp_project)
    subproject = hostname.split('.')[1]

    if subproject.nil?
      # No subproject component in the hostname, so default to 'shared'
      'shared'
    else
      # Convert the subproject to a number
      subproject_id = case subproject
                      when 'niwc' then '064'
                      when 'lenovo' then '065'
                      when 'wsr' then '066'
                      when 'ido' then '067'
                      else
                        # Unknown subproject, default to 'shared'
                        'shared'
                      end

      # Check if the project ID is 'shared' and replace it with the subproject ID
      project_id == 'shared' ? subproject_id : project_id
    end
  end
end
