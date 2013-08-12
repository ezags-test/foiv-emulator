module ApplicationHelper
  def websocket_url
    [request.host_with_port, '/websocket'].join
  end
end
