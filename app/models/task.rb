class Task < ApplicationRecord
  after_commit :reload_tags, on: :update

  has_and_belongs_to_many :tags, autosave: true

  validates :title, presence: true, length: {minimum: 3}

  def tags=(tags)
    unless tags.nil? || tags.empty?
      super(tags.map { |value|
        if value.is_a?(String)
          Tag.find_or_initialize_by(title: value) #force to find existing Tags when possible
        else
          value
        end
      })
    end
  end

  default_scope { order(title: :asc) }

  private

  def reload_tags
    tags.reload #need to reload to keep right order on title change
  end

end
