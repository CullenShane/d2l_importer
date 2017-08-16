module ResourceConsumer

  def consume_resources(manifest)
    manifest.css('resource').each do |r_node|
      id = r_node['identifier']
      resource = @resources[id]
      resource ||= {:migration_id=>id}
      resource[:type] = r_node['type']
      resource[:href] = r_node['href']
      if resource[:href]
        resource[:href] = resource[:href].gsub('\\', '/')
      end
      resource[:material_type] = r_node.find {|k,v| k.match('material_type') }[1]
      @resources[id] = resource
    end
    @resources
  end

end
