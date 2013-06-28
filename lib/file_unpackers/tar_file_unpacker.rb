require 'zlib'
require 'archive/tar/minitar'

module FileUnpackers
  class TarFileUnpacker
    def self.unpack_file(compressed_file, destination_path)
      Archive::Tar::Minitar.unpack(File.open(compressed_file, 'rb'), destination_path)
    end
  end
end