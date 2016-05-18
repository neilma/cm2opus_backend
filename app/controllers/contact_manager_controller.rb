require_relative '../../lib/ws/web_service_helper'
require_relative '../../lib/db/oracle_db_client'

class ContactManagerController < ApplicationController

  CM_FIELDS = %w(link_id abn_ext email_address1 fax_phone home_phone work_phone name)
  CM_PRIMARY_ADDR_FIELDS = %w(address_line1 city state postal_code)

  before_action :authenticate_user!, unless: :has_client_token?

  def has_client_token?
    User.find_by_reset_password_token(request.params[:authenticity_token]).present?
  end

  def search_contacts
    wh = WebServiceHelper.new(params[:cm_env], params[:operation],
                              "#{Rails.root}/lib/ws/#{params[:operation]}.xml.erb", params[:contact_manager])
    savon_resp = wh.send_soap_request
    # nokogiri_doc_resp = savon_resp.doc
    # nokogiri_doc_resp.remove_namespaces!

    respond_to do |format|
      format.json { render json: savon_resp_handler(savon_resp).tap{|i| puts i} }
    end
  end

  def search_results_filter(hash_resp)
    Array.wrap(hash_resp[:search_contact_response][:return][:results][:entry]).inject([]) do |memo, obj|
      sliced_contact_hash = obj.with_indifferent_access.slice(*CM_FIELDS)
      sliced_primary_address = obj[:primary_address].with_indifferent_access.slice(*CM_PRIMARY_ADDR_FIELDS)
      memo << sliced_contact_hash.merge(sliced_primary_address)
      memo
    end
  end

  def sync_contacts
    @current_time = Time.now
    sync_results = []
    supplier_req_data = params[:supplier_data].try(:values) || params[:supplier_data]
    Array.wrap(supplier_req_data).each do |result|
      sync_result = {}
      set_opus_vars result
      sync_sql_erbs.each do |erb|
        db_rval = query_opus build_sql(erb), 'db_upsert'
        sync_result[result[:link_id]] = db_rval
        break unless db_rval == :success
      end
      sync_results.push(sync_result)
    end
    respond_to do |format|
      format.json { render json: sync_results.to_json }
    end
  end

  def query_opus(sql_query, transaction_type='db_query')
    OracleDbClient.new(params[:opus_env], nil, nil).query(sql_query, transaction_type)
  end

  def build_sql(sql_erb_file_path)
    ERB.new(File.read(sql_erb_file_path)).result(binding).tap{ |i| puts i}
  end

  def set_opus_vars(input_json)
    @supplier_id = rand(90000..99999).to_s
    @contact_manager_id = input_json[:link_id].to_s
    @supplier_name = input_json[:name].gsub("'", "''").to_s
    @abn = input_json[:abn_ext].to_s.gsub("-", "")
    @email = input_json[:email_address1].to_s
    @work_phone = input_json[:work_phone].to_s
    @home_phone = input_json[:home_phone].to_s
    @fax = input_json[:fax_phone].to_s
    @street = input_json[:address_line1].to_s
    @suburb = input_json[:city].to_s
    @state = input_json[:state].to_s.gsub("AU_", "")
    @postcode = input_json[:postal_code].to_s
    @db_schema = 'DB2O0001'
  end

  def sync_sql_erbs
    ["#{Rails.root}/lib/db/sql/upsert_supplier.sql.erb", "#{Rails.root}/lib/db/sql/upsert_user.sql.erb"]
  end

  def savon_resp_handler(resp)
    return search_results_filter(resp.body) if resp.class == Savon::Response
    resp
  end

end
