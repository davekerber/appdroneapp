require 'zlib'
require 'archive/tar/minitar'

module FileUnpackers
  class TarGzFileUnpacker
    def self.unpack_file(compressed_file, destination_path)
      tgz = Zlib::GzipReader.new(File.open(compressed_file, 'rb'))
      Archive::Tar::Minitar.unpack(tgz, destination_path)
    end
  end
end