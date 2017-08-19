module DiscussionConverter

  def convert_discussions(resources)
    discussions = []

    resources_by(resources, 'd2ldiscussion', :material_type).each do |res|
      discussions << self.discuss_this(res[:href])

    end

    discussions
  end

  def discuss_this(discussion_path)
    discussion = {}

    file = open_file(File.join(@unzipped_file_path, discussion_path))
    file.css('discussion forum').each do |forum|
      discussion[:migration_id] = forum['resource_code']
      discussion[:migration_id] ||= forum['id']
      forum.css('properties').children.each do |p_node|
        discussion[:require_initial_post] = p_node.text if p_node.name == 'must_post_to_participate'
        discussion[:position] = p_node.text if p_node.name == 'display_order'
      end
      discussion[:title] = forum.css('content title').first.text
      discussion[:description] = forum.css('content description').first.text
    end

    discussion
  end

end
