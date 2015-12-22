require 'nokogiri'
require 'open-uri'
require 'erubis'

class IsoCountryCodes
  module Task
    module UpdateJapaneseName
      def self.get
        doc    = Nokogiri::HTML.parse(open('https://ja.wikipedia.org/wiki/ISO_3166-1'), nil, 'UTF-8')
        codes  = {}
        td_map = {
          name:   1,
          iso:    2,
          numeric: 3,
          alpha3: 4,
          alpha2: 5
        }

        code_labels = td_map.keys

        doc.search('table.wikitable.sortable tr').each do |row|
          value_hash = {}

          code_labels.each do |key|
            selector = "td:nth-of-type(#{td_map[key]})"
            selector << ' a' if key == :name

            value = row.search(selector).text.strip

            next if value == ''

            value_hash[key] = value

            if value_hash.length == code_labels.length - 1
              value_hash.keys.each do |value_hash_key|
                codes[value_hash[value_hash_key]] = value_hash if value_hash_key == :alpha3
              end
            end
          end
        end

        to_ruby(codes) if codes
      end

      def self.to_ruby(codes)
        tmpl  = File.read(File.join(File.dirname(__FILE__), 'japanese.rb.erb'))
        eruby = Erubis::Eruby.new(tmpl)
        eruby.result(:codes => codes)
      end
    end # UpdateCodes
  end # Task
end # IsoCountryCodes
