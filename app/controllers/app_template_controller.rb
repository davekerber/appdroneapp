class AppTemplateController < ApplicationController
  def build
    t = AppDrone::Template.new
    drones = params[:drones] || {}
    drones.each do |human_name,params|
      # classify the string drone name
      drone_klass = human_name.titleize.gsub(' ','').underscore.to_sym.to_app_drone_class

      # make sure there is a symbolized hash of params available
      drone_params = params.symbolize_keys

      # convert 'true' and 'false' param values to their boolean counterparts
      drone_params.each { |key,value|
        drone_params[key] = (value == 'true') if %w{true false}.include?(value)
      }
      t.add drone_klass, drone_params
    end

    builder = t.render_with_wrapper

    @app_template = AppTemplate.create({ builder: builder })
    render text: app_template_path(uuid: @app_template.uuid)
  end

  def new
  end

  def show
    @app_template = AppTemplate.find_by_uuid(params[:uuid])
    render text: @app_template.builder and return if params[:format] == 'rb'
  end
end
