if Rails.application.config.respond_to? :contrib_drones_path
  contrib_path = Rails.application.config.contrib_drones_path

  if contrib_path && Dir.exists?(contrib_path)
    AppDrone.require_drones_at_path(contrib_path)
  end
end

