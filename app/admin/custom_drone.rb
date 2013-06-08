require 'file_unpackers/tar_gz_file_unpacker'
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

        if object.valid?
          contrib_path = Rails.application.config.contrib_drones_path
          destination_path = "#{contrib_path}/#{object.slug}"
          FileUnpackers::TarGzFileUnpacker.unpack_file(uploaded_file, destination_path)

          require "#{contrib_path}/#{object.slug}/#{object.slug}.rb"

          class_name = object.slug.camelize
          drone_class = AppDrone.const_get(class_name)
          object.name = drone_class.human_name
          object.description = drone_class.desc
          object.category = drone_class.category

          object.save
          options[:location] ||= smart_resource_url
        end

        respond_with_dual_blocks(object, options)
      end

      if params[:custom_drone][:git_url]
        params[:custom_drone].delete :packaged_drone

        object = build_resource
        object.slug = object.git_url.split('.')[-2].split('/')[-1]
        if object.valid?
          checkout_path = File.join(Rails.application.config.contrib_drones_path, object.slug)
          git_repo = Git.clone(object.git_url, checkout_path)
          object.git_revision = git_repo.log.max.sha

          require File.join(checkout_path, "#{object.slug}.rb")

          class_name = object.slug.camelize
          drone_class = AppDrone.const_get(class_name)
          object.name = drone_class.human_name
          object.description = drone_class.desc
          object.category = drone_class.category

          object.save
          options[:location] ||= smart_resource_url
        end

        respond_with_dual_blocks(object, options)
      end
    end
  end
end
