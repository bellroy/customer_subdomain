class CustomerSubdomainGenerator < Rails::Generator::Base
  default_options :generate_model => true,
                  :model_name => "Customer",
                  :field_name => "subdomain"

  attr_reader :model, :field

  def manifest
    @model = options[:model_name].underscore
    @field = options[:field_name].underscore

    record do |m|
      m.template "initializer.rb.erb", File.join("config", "initializers", "customer_subdomain.rb")

      if options[:generate_model]
        m.template "model.rb.erb", File.join("app", "models", "#{@model}.rb")
        m.template "spec.rb.erb", File.join("spec", "models", "#{@model}_spec.rb")
        m.template "migration.rb.erb", File.join("db", "migrate", "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{@model.pluralize}.rb")
      end
    end
  end

  def add_options!(opt)
    opt.separator ""
    opt.separator "Options:"
    opt.on("--no-model", "Don't generate the model files (class, migration, spec, ...)") { |value| options[:generate_model] = value }
    opt.on("--model-name=model", "Use a different model (Default: Customer)") { |value| options[:model_name] = value }
    opt.on("--subdomain-field=field", "Use a different field to map against the subdomain (Default: subdomain)") { |value| options[:field_name] = value }
  end
end
