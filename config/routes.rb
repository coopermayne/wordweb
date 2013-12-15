WordwebApp::Application.routes.draw do
  get "data" => 'words#index'
  root :to => 'welcome#index'
end
