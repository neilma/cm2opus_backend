class WebServiceHelper
  # assign in init
  attr_accessor :env, :operation, :xml_erb_file_path, :binding_vars, :client, :endpoint
  # assign in methods
  attr_accessor :resp, :xml_payload

  def initialize(*args)
    @env, @operation, @xml_erb_file_path, @binding_vars, @endpoint = args
    @operation = @operation.to_sym
    @client = Savon.client(build_savon_args)
  end

  def send_soap_request
    @resp =
    begin
      client.call(operation, xml: erb_binding.tap{|i| puts i})
    rescue => e
      { error: { e.class => e.message } }
    end.tap{|i| puts i}
  end

  def erb_binding
    set_instance_vars_from_hash
    @xml_payload = ERB.new(File.read(xml_erb_file_path)).result(binding)
  end

  private
  def set_instance_vars_from_hash
    return unless binding_vars.present?
    binding_vars.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def build_savon_args
    savon_args = { wsdl: wsdl_url, logger: Rails.logger, log_level: :debug }
    savon_args[:endpoint] = endpoint if endpoint.present?
    savon_args
  end

  def wsdl_url
    cm_config = YAML.load(File.open("#{Rails.root}/config/cm.yml"))[env]
    @username, @password = cm_config["username"], cm_config["password"]
    puts cm_config["wsdl"]
    cm_config["wsdl"]
  end
end
