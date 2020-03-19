class ApplicationController < ActionController::Base
  def hello
    render html: "This works!"
end
end