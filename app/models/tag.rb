class Tag < ApplicationRecord
  has_and_belongs_to_many :tasks, autosave: false

  validates :title, presence: true, uniqueness: true, length: {minimum: 3}
end
