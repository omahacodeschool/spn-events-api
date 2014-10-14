SpEventApi::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'all_spn_events' => 'spn_events#all_events'
    end
  end
end
