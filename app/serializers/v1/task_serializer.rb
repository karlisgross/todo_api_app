module V1
  class TaskSerializer < ActiveModel::Serializer
    attributes :id, :title

      has_many :tags

      def include_tags?
        object.association(:tags).loaded?
      end
    end
end
