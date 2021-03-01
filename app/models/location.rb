class Location < ApplicationRecord
  self.table_name = 'locations'
  self.primary_key = :location_id

  validates_presence_of :user_id, :location_name, :tag, :longtitude, :latitude
  validates :tag, inclusion: { in: :location_tags }

  has_many_attached :pictures
  
  belongs_to :user, class_name: User.name,
  foreign_key: :user_id, primary_key: :id

  def location_tags
    %W(FOOD HOME VACATION OTHER)
  end
end
