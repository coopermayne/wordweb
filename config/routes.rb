WordwebApp::Application.routes.draw do
  get "data" => 'words#index'
  root :to => 'welcome#welcome'
  get 'bewdrow' => 'welcome#index'
end
