class ApplicationController < ActionController::Base
   http_basic_authenticate_with name: "admin",
                                password: Rails.application.credentials.basicauth[:pass],
                                except: [:report, :trend]
end
