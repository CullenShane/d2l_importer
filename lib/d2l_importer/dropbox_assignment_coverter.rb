module DropboxAssignmentConverter

  def convert_dropboxes(resources)
    assignments = []

    resources_by(resources, 'd2ldropbox', :material_type).each do |res|
      assignments = [*assignments, *self.drop_this_box(res[:href])]
    end

    assignments
  end

  def drop_this_box(href)
    assignments = []

    file = open_file(File.join(@unzipped_file_path, href))
    file.css('dropbox folder').each do |folder|
      assignment = {}
      assignment[:instructions_in_html] = true
      assignment[:instructions] = folder.css('instructions text').first.text
      assignment[:grading_type] = 'points'
      assignment[:points_possible] = folder['out_of']
      assignment[:migration_id] = folder['resource_code']
      assignment[:submission_format] = 'online_upload'
      assignment[:title] = folder['name']
      assignments << assignment
    end

    assignments
  end
end
