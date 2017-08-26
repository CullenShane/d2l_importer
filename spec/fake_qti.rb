module Qti
  module Flavors
    D2L = 'd2l'
  end

  def self.convert_xml(xml_file_contents, opts={})
    raise "xml file CONTENTS" unless xml_file_contents.is_a? String
    [[{}], [{title: '5.6 A1 Multiplying Exponential Expressions'}]]
  end
end
