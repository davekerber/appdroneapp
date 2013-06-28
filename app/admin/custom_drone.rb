require 'file_unpackers/tar_gz_file_unpacker'
require 'file_unpackers/tar_file_unpacker'
require 'file_unpackers/zip_file_unpacker'
require 'file_unpackers/ruby_file_unpacker'
require 'git'

ActiveAdmin.register CustomDrone do
  index do
    column :name
    default_actions
  end

  form do |f|
    f.form_buffers.last << content_tag(:h3, "Enter a Git url OR select a file to upload")
    f.inputs "Git URL" do
      f.input :git_url
    end

    f.inputs "Packaged Drone" do
      f.input :packaged_drone, as: :file
    end

    f.actions
  end


  controller do
    def create
      options = {}
      if params[:custom_drone][:packaged_drone]
        uploaded_file_name = params[:custom_drone][:packaged_drone].original_filename
        uploaded_file = params[:custom_drone][:packaged_drone].tempfile
        params[:custom_drone].delete :packaged_drone

        object = build_resource
        object.slug = uploaded_file_name.split('.')[0]
        extension = uploaded_file_name.split('.')[1..-1].join('.')

        if object.valid?
          if extension == 'tar.gz'
            unpacker = FileUnpackers::TarGzFileUnpacker
          elsif extension == 'tar'
            unpacker = FileUnpackers::TarFileUnpacker
          elsif extension == 'zip'
            unpacker = FileUnpackers::ZipFileUnpacker
          elsif extension == 'rb'
            unpacker = FileUnpackers::RubyFileUnpacker
          else
            raise 'Unknown File Type'
          end

          unpacker.unpack_file(uploaded_file, object.file_system_path)
          object.copy_metadata_from_drone_class
          object.save

          options[:location] ||= smart_resource_url
        end

        respond_with_dual_blocks(object, options)
      end

      git_url = params[:custom_drone][:git_url]
      if git_url && !git_url.blank?
        params[:custom_drone].delete :packaged_drone

        object = build_resource
        object.slug = object.git_url.split('.')[-2].split('/')[-1]
        if object.valid?
          git_repo = Git.clone(object.git_url, object.file_system_path)
          object.git_revision = git_repo.log.max.sha

          object.copy_metadata_from_drone_class
          object.save

          options[:location] ||= smart_resource_url
        end

        respond_with_dual_blocks(object, options)
      end
    end
  end
end
