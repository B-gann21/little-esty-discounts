Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/merchants/:id/items", to: "merchant_items#index"
  get "/merchants/:id/items/new", to: "merchant_items#new"
  post "/merchants/:id/items", to: "merchant_items#create"
  get "/merchants/:id/items/:id", to: "merchant_items#show"
  get "/merchants/:id/items/:id/edit", to: "merchant_items#edit"
  patch "/merchants/:id/items/:id", to: "merchant_items#update"
  patch "/items/:id", to: 'items#update'

  get 'merchants/:id/dashboard', to: 'merchants#show'

  get '/merchants/:id/bulk_discounts', to: 'merchant_bulk_discounts#index'
  post '/merchants/:id/bulk_discounts', to: 'merchant_bulk_discounts#create'
  get '/merchants/:id/bulk_discounts/new', to: 'merchant_bulk_discounts#new'
  get '/merchants/:id/bulk_discounts/:discount_id', to: 'merchant_bulk_discounts#show'
  patch '/merchants/:id/bulk_discounts/:discount_id', to: 'merchant_bulk_discounts#update'
  get '/merchants/:id/bulk_discounts/:discount_id/destroy', to: 'merchant_bulk_discounts#destroy'
  get '/merchants/:id/bulk_discounts/:discount_id/edit', to: 'merchant_bulk_discounts#edit'

  get 'merchants/:id/invoices', to: 'merchant_invoices#index'
  get 'merchants/:merchant_id/invoices/:invoice_id', to: 'merchant_invoices#show'
  patch 'merchants/:merchant_id/invoices/:invoice_id', to: 'merchant_invoices#update'

  get '/admin/merchants', to: 'admin_merchants#index'
  get '/admin/merchants/new', to: 'admin_merchants#new'
  post '/admin/merchants', to: 'admin_merchants#create'
  get '/admin/merchants/:id', to: 'admin_merchants#show'
  get '/admin/merchants/:id/edit', to: 'admin_merchants#edit'
  patch '/admin/merchants/:id', to: 'admin_merchants#update'
  patch "/merchants/:id", to: 'merchants#update'

  get '/admin/invoices', to: 'admin_invoices#index'
  get '/admin/invoices/:id', to: 'admin_invoices#show'
  patch '/admin/invoices/:id', to: 'admin_invoices#update'

  get '/admin', to: 'admin#index'
end
