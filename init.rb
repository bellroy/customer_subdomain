require 'customer_subdomain'

class ActionController::Base
  include CustomerSubdomain::Helper
end
