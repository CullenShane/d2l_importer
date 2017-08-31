module OrganizationReorganizer

  def reorganize_organization(manifest)
    modules = []
    return modules unless manifest

    manifest.css('organizations organization > item').each do |item|
      mod = {items: []}
      mod[:migration_id] = item['identifier']
      add_child_items(item, mod)
      modules << mod
    end
    modules
  end

  def add_child_items(parent_item, mod)
    parent_item.children.each do |item|
      if item.name == 'title'
        mod[:title] = item.text
      else
        if item = process_item(item)
          mod[:items] << item
        end
      end
    end
  end

  def process_item(item_node)
    mod_item = nil
    res = @resources[item_node['identifierref']]
    return mod_item if res.nil?
    case res[:material_type]
      when 'contentmodule'
        mod_item = {type: 'submodule', items: []}
        add_child_items(item_node, mod_item)
      when 'content'
        mod_item = {
          type: 'linked_resource',
          item_migration_id: item_node['identifier'],
          linked_resource_id: item_node['identifierref'],
          linked_resource_title: get_node_val(item_node, 'title'),
          linked_resource_type: 'wikipage'
        }
      when 'contentlink'
        # This needs to parse the special href that's there and get the wacky hash ID out, it also needs
        # to setup the linked_resource_type to be correct for the D2l type
        if get_d2l_type_from(res[:href]) == 'url'
          mod_item = {
            type: 'linked_resource',
            item_migration_id: item_node['identifier'],
            url: res[:href],
            workflow_state: 'published',
            linked_resource_title: get_node_val(item_node, 'title'),
            linked_resource_type: get_d2l_type_from(res[:href])
          }
        else
          mod_item = {
            type: 'linked_resource',
            item_migration_id: item_node['identifier'],
            linked_resource_id: get_d2l_code_from(res[:href]),
            linked_resource_title: get_node_val(item_node, 'title'),
            linked_resource_type: get_d2l_type_from(res[:href])
          }
        end

    end
    mod_item
  end

  def get_d2l_code_from(href)
    matcher = /rCode=(?<code>[0-9a-z-]+)/
    if matcher.match?(href)
      matcher.match(href)[:code]
    end
  end

  def get_d2l_type_from(href)
    matcher = /type=(?<type>[a-z]+)/
    if not matcher.match?(href)
      begin
        uri = URI.parse(href)
        if ['http', 'https'].include? uri.scheme
          return 'url'
        end
      rescue URI::InvalidURIError
        return nil
      end
    end
    return if matcher.match(href).nil?
    case matcher.match(href)[:type]
      when 'discuss'
        'discussion'
      else
        matcher.match(href)[:type]
    end
  end

end
