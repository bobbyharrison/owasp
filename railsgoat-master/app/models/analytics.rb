# frozen_string_literal: true
class Analytics < ApplicationRecord
  scope :hits_by_ip, ->(ip, col = "*") { select("#{col}").where(ip_address: ip).order("id DESC") }

  def self.count_by_col(col)
    calculate(:count, col)
  end

  def self.parse_field(field)
    valid_fields = ["ip_address", "referrer", "user_agent"]

    if valid_fields.include?(field)
      field
    else
      "1"
    end
  end

  def analytics
  if params[:field].nil?
    fields = "*"
  else
   fields = params[:field].map {|k,v| Analytics.parse_field(k) }.join(",")
  end

  if params[:ip]
    @analytics = Analytics.hits_by_ip(params[:ip], fields)
  else
    @analytics = Analytics.all
  end
  render "layouts/admin/_analytics"
end
end
