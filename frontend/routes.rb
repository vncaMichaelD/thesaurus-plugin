ArchivesSpace::Application.routes.draw do

    match 'thesas/defaults' => 'thesas#defaults', :via => [:get]
    match 'thesas/defaults' => 'thesas#update_defaults', :via => [:post]
    resources :thesas
    match 'thesas/:id' => 'thesas#update', :via => [:post]
    match 'thesas/:id/delete' => 'thesas#delete', :via => [:post]

end
