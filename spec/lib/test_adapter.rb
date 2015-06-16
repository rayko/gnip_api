class TestAdapter
  def post request
    return GnipApi::Response.new(200, 'post_result', {:status => 'OK'})
  end
  
  def delete request
    return GnipApi::Response.new(200, 'delete_result', {:status => 'OK'})
  end
  
  def get request
    return GnipApi::Response.new(200, 'get_result', {:status => 'OK'})
  end

  def stream_get request
  end
end
