class CustomDrone < ActiveRecord::Base
  attr_accessible :git_url

  validates :slug, :uniqueness => true, :length => {maximum: 100}, :presence => true
  #validates :name, :length => {maximum: 200}, :presence => true
  #validates :category, :length => {maximum: 25}, :presence => true
  #validates :description, :presence => true


end
