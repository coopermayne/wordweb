class WordsController < ApplicationController
  def index
    data = Root.all.sample.nested_json
    render json: data
  end
end
