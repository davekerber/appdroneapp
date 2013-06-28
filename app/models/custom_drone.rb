class CustomDrone < ActiveRecord::Base
  attr_accessible :git_url

  validates :slug, :uniqueness => true, :length => {maximum: 100}, :presence => true
  #validates :name, :length => {maximum: 200}, :presence => true
  #validates :category, :length => {maximum: 25}, :presence => true
  #validates :description, :presence => true

  before_destroy :destroy_file_system_contents

  def destroy_file_system_contents
    FileUtils.rm_rf file_system_path
  end

  def file_system_path
    contrib_path = Rails.application.config.contrib_drones_path
    "#{contrib_path}/#{self.slug}"
  end

  def main_file_path
    "#{file_system_path}/#{self.slug}.rb"
  end

  def drone_class_name
    self.slug.camelize
  end

  def load_drone
    require main_file_path
  end

  def drone_class
    AppDrone.const_get(self.drone_class_name)
  end

  def copy_metadata_from_drone_class
    self.load_drone
    clazz = self.drone_class

    self.name = clazz.human_name
    self.description = clazz.desc
    self.category = clazz.category

  end

end