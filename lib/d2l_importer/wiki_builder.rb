module WikiBuilder

  def create_d2l_wikis(manifest)
    wikis = []

    manifest.css("resource[type=webcontent][href$='.html'][href]:not([href^='http'])").each do |res|
      wiki = {}
      wiki[:migration_id] = res['identifier']
      wiki[:path_name] = res['href']
      wiki[:file_name] = File.basename wiki[:path_name]
      wiki[:url_name] = wiki[:title] = File.basename wiki[:path_name].sub(".html", '')
      file_path = File.join(@unzipped_file_path, wiki[:real_path] || wiki[:path_name])
      if File.exists?(file_path)
        @ignored_files << file_path
        wiki[:text] = File.read(file_path)
      else
        add_warning(I18n.t('canvas.migration.errors.file_does_not_exist', 'The wiki page "%{file_path}" did not exist in the content package and could not be imported.', :file_path => file_path))
      end

      wikis << wiki
    end

    manifest.css('item[description]:not([description=""])').each do |item|
      wiki = {}
      wiki[:migration_id] = item['identifierref']
      wiki[:path_name] = get_node_val(item, 'title')
      wiki[:title] = wiki[:path_name]
      wiki[:text] = item[:description]

      wikis << wiki
    end

    wikis
  end

end
