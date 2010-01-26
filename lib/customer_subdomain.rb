class CustomerSubdomain
  cattr_accessor :model_name, :field_name

  module Helper
    def self.included(recipient)
      recipient.class_eval do
        include InstanceMethods

        helper_method(:current_customer) if recipient.respond_to?(:helper_method)
      end
    end

    module InstanceMethods

    private

      def current_customer; @customer ||= Customer.send("find_by_#{CustomerSubdomain.field_name}", request.subdomains.first) end
    end
  end
end
