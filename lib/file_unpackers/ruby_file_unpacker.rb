require 'fileutils'

module FileUnpackers
  class RubyFileUnpacker
    def self.unpack_file(compressed_file, destination_path)
      Dir.mkdir(destination_path)
      file_name = destination_path.split(File::SEPARATOR)[-1]
      FileUtils.cp(compressed_file, "#{destination_path}/#{file_name}.rb")
    end
  end
end