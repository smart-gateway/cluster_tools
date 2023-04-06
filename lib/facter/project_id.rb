require 'facter'

Facter.add('project_id') do
  setcode do
    project_id = nil
    pp_project = Facter.value('trusted.extensions.pp_project')
    if pp_project
      case pp_project
      when 'shared'
        project_id = 'shared'
      when 'niwc'
        project_id = '064'
      when 'lenovo'
        project_id = '065'
      when 'wsr'
        project_id = '066'
      when 'ido'
        project_id = '067'
      else
        project_id = 'unknown'
      end
    end
    return project_id
  end
end
