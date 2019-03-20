#flattens Json Api request into a regular param hash
class JsonApiRequestParams

  def initialize(params)
    data = params[:data]
    unless data && data[:attributes] #GET request
      @attrs = params.permit(:id)
      return
    end

    #try to get id from URL if none found in data
    id = data.permit(:id, :type, :attributes)[:id] || params.permit(:id, :data)[:id]

    @attrs = data.require(:attributes) || {}
    @attrs[:id] = id
  end

  def permit(*args)
    @attrs.permit(*args)
  end

  def to_h
    @attrs.to_h
  end

  def require(*args)
    @attrs.require(*args)
  end
end