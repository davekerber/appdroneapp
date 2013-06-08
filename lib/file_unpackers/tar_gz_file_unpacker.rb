require 'zlib'
require 'archive/tar/minitar'

module FileUnpackers
  class TarGzFileUnpacker
    def self.unpack_file(compressed_file, destination_path)
      tgz = Zlib::GzipReader.new(File.open(compressed_file, 'rb'))
      #contrib_path = Rails.application.config.contrib_drones_path
      #destination_path = "#{contrib_path}/#{drone_name}"
      Archive::Tar::Minitar.unpack(tgz, destination_path)
    end
  end
end