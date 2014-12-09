#!/usr/bin/env ruby

module MetadataJsonLint
  def MetadataJsonLint.parse(metadata)

    f = File.read(metadata)

    begin
      parsed = JSON.parse(f)
    rescue
      abort("Error: Unable to parse json. There is a syntax error somewhere.")
    end

    # Fields required to be in metadata.json
    # From: https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file
    error_state = false

    required_fields = [ "name", "version", "author", "license", "summary", "source", "dependencies" ]

    required_fields.each do |field|
      if parsed[field].nil?
        puts "Error: Required field '#{field}' not found in metadata.json."
        error_state = true
      end
    end



    # Deprecated fields
    # From: https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file

    deprecated_fields = ["types", "checksum"]

    deprecated_fields.each do |field|
      if not parsed[field].nil?
        puts "Error: Deprecated field '#{field}' found in metadata.json."
        error_state = true
      end
    end



    # Shoulds/recommendations
    # From: https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file

    if !parsed['license'].nil? && !SpdxLicenses.exist?(parsed['license'])
      puts "Warning: License identifier #{parsed['license']} is not in the SPDX list: http://spdx.org/licenses/"
      error_state = true
    end


    if error_state
      abort("Errors found in metadata.json")
    end

  end
end
