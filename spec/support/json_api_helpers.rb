module JsonApiHelpers
  def build_json_api_request(params, type: nil)
    {id: params[:id], data: {id: params[:id], type: type, attributes: params.except(:id)}}
  end

  def expect_json_api_error(message, code: :bad_request)
    expect(response).to have_http_status(code)
    expect(response.content_type).to eq('application/json')

    expect(response.body).to have_json_path("errors")
    expect(response.body).to_not have_json_size(0).at_path("errors")

    expect(response.body).to include_json({message: message, status: code}.to_json).at_path("errors")
  end

  def expect_json_api_response(attributes, id: nil, included: nil, relationships: nil, code: :ok, as_array: false)
    expect(response).to have_http_status(code)
    expect(response.content_type).to eq('application/json')

    expect(response.body).to have_json_path("data")
    expect(response.body).to_not have_json_path("errors")

    if as_array
      expect(response.body).to be_json_eql(attributes.to_json).at_path("data/0/attributes")
      expect(response.body).to have_json_path("data/0/relationships/#{relationships}") if relationships
    else
      expect(response.body).to be_json_eql(attributes.to_json).at_path("data/attributes")
      expect(response.body).to have_json_path("data/relationships/#{relationships}") if relationships
    end

    expect(response.body).to be_json_eql(id.to_json).at_path("data/id") if id

    if included
      expect(response.body).to have_json_path("included")
      included.each_with_index do |obj, idx|
        expect(response.body).to be_json_eql(obj.to_json).at_path("included/#{idx}/attributes")
      end
    end
  end
end