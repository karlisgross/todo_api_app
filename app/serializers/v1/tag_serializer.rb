module V1
  class TagSerializer < ActiveModel::Serializer
    attributes :id, :title

    has_many :tasks

    def include_tasks?
      object.association(:tasks).loaded?
    end
  end
end


