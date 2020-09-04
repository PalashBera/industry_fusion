Rails.application.routes.draw do
  namespace :master do
    concern :exportable do
      get :export, on: :collection
    end

    concern :importable do
      post :import, on: :collection
    end

    concern :change_logable do
      get :change_logs, on: :member
    end

    resources :brands,              except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :indentors,           except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :uoms,                except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :item_groups,         except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :cost_centers,        except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :items,               except: %i[show destroy], concerns: %i[exportable change_logable]
    resources :makes,               except: %i[show destroy], concerns: %i[exportable change_logable]
    resources :warehouse_locations, except: %i[show destroy], concerns: %i[exportable change_logable]
    resources :reorder_levels,      except: %i[show destroy], concerns: %i[exportable change_logable]
    resources :payment_terms,       except: %i[show destroy], concerns: %i[exportable importable change_logable]
    resources :item_images,         only: %i[index destroy]

    resources :vendors, only: %i[index new create], concerns: %i[exportable importable] do
      member do
        put :resend_invitation
        get :toggle_archive
      end
    end
  end
end
