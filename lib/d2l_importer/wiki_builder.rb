module WikiBuilder

  def create_wikis(manifest)
    wikis = []

    manifest.css("resource[type=webcontent][href$='.html']").each do |res|
      wiki = {}
      wiki[:migration_id] = res['identifier']
      wiki[:path_name] = res['href']
      wiki[:file_name] = File.basename wiki[:path_name]
      wiki[:url_name] = wiki[:title] = File.basename wiki[:path_name].sub(".html", '')
      wiki[:type] = 'PAGE_TYPE'
      file_path = File.join(@unzipped_file_path, wiki[:real_path] || wiki[:path_name])
      if File.exists?(file_path)
        wiki[:text] = File.read(file_path)
      else
        add_warning(I18n.t('canvas.migration.errors.file_does_not_exist', 'The wiki page "%{file_path}" did not exist in the content package and could not be imported.', :file_path => file_path))
      end

      wikis << wiki
    end

    wikis
  end

end
