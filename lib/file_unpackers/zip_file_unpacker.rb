require 'zipruby'
require 'fileutils'

module FileUnpackers
  class ZipFileUnpacker
    def self.unpack_file(compressed_file, destination_path)
      puts compressed_file.class
      p compressed_file
      Zip::Archive.open(compressed_file.path) do |ar|
        ar.each do |zf|
          if zf.directory?
            FileUtils.mkdir_p(File.join(destination_path, zf.name))
          else
            dirname = File.dirname(File.join(destination_path, zf.name))
            FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

            open(File.join(destination_path, zf.name), 'wb') do |f|
              f << zf.read
            end
          end
        end
      end
    end
  end
end