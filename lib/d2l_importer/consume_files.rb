module ConsumeFiles

  def create_d2l_file_map
    file_map = {}

    files = Dir["#{@unzipped_file_path}/**/*"]
    files -= @ignored_files
    files.each do |file|
      file.gsub!("#{@unzipped_file_path}/", '')
      file_hash = {}
      file_hash[:migration_id] = file
      file_hash[:path_name] = file
      file_hash[:file_name] = File.basename(file)
      file_hash[:type] = 'FILE_TYPE'

      file_map[file_hash[:migration_id]] = file_hash
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
