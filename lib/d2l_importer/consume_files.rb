module ConsumeFiles

  def create_file_map(resources)
    file_map = {}

    # This should capture all files that AREN'T D2L files or otherwise and store them so they can be
    # accessed by the wiki pages as content

    # resources.css("resource[type=webcontent][href$='.html'][material_type='content']").each do |res|
    resources_by(resources, :material_type, 'content', 'webcontent').each do |res|
      file = {}
      # file[:migration_id] = res['identifier']
      # file[:path_name] = res['href']
      # file[:file_name] = File.basename file[:path_name]
      # file[:type] = 'FILE_TYPE'
      #
      # file_map[file[:migration_id]] = file
    end

    file_map
  end

  def package_course_files(course)
    zip_file = File.join(@base_export_dir, 'all_files.zip')
    make_export_dir
    path = @unzipped_file_path
    Zip::File.open(zip_file, 'w') do |zipfile|
      course[:file_map].each_value do |val|
        file_path = File.join(path, val[:real_path] || val[:path_name])
        val.delete :real_path
        if File.exist?(file_path)
          zipfile.add(val[:path_name], file_path)
        else
          add_warning(I18n.t('canvas.migration.errors.file_does_not_exist', 'The file "%{file_path}" did not exist in the content package and could not be imported.', :file_path => file_path))
        end
      end
    end
    File.expand_path(zip_file)
  end

end
