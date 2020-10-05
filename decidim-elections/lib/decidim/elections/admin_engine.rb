# frozen_string_literal: true

module Decidim
  module Elections
    # This is the engine that runs on the public interface of `Elections`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Elections::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        get "/answer_options", to: "feedback_forms#answer_options", as: :answer_options_election_feedback, defaults: { format: "json" }

        resources :elections do
          member do
            put :publish
            put :unpublish
            resource :feedback_form, only: [:edit, :update] do
              collection do
                get :answers, to: "feedback_forms#index"
                get "/answer/:session_token", to: "feedback_forms#show", as: :answer
                get "/answer/:session_token/export", to: "feedback_forms#export_response", as: :answer_export
              end
            end
          end
          resources :questions do
            resources :answers do
              collection do
                get :proposals_picker
                resource :proposals_import, only: [:new, :create]
              end
            end
          end
        end

        root to: "elections#index"
      end

      def load_seed
        nil
      end
    end
  end
end
