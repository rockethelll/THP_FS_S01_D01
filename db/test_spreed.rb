# frozen_string_literal: true

# require 'google_drive'

# session = GoogleDrive::Session.from_config("db/email.json")

# ws = session.spreadsheet_by_key

require 'csv'
require 'json'

# require_relative 'email.json'

csv_string = CSV.generate do |csv|
  JSON.parse(File.open('./email.json').read).each do |hash|
    csv << hash.values
  end
end

puts csv_string
