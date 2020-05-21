class ScriptsController < ApplicationController
  def index
    @scripts = Script.all
  end

  def show
    @script = Script.find(params[:id])
  end
end
