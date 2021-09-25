class Official < ActiveRecord::Base

  OFFICIALS_URL = "https://www.googleapis.com/civicinfo/v2/representatives?key=#{ENV['GOOGLE_API_KEY']}"

  def self.process_officials(data)
    json = JSON.parse(data).with_indifferent_access
    officials = json[:officials]
    division = json[:division]
    offices = json[:offices]

    officials_json = officials.map.with_index do |off, idx|
      office = offices.find {|o| o[:officialIndices].include?(idx)}
      emails = off[:emails]
      urls = off[:urls]
      phones = off[:phones]
      {
        id: idx,
        name: off[:name],
        party: off[:party],
        phone: phones.present? ? phones.join(',') : 'Unknown',
        url: urls.present? ? urls.first : 'Unknown',
        email: emails.present? ? emails.join(',') : 'Unknown',
        position: office.present? ? office[:name] : 'Unknown',
        photoUrl: off[:photoUrl] || '/images/blank_avatar.png'
      }
    end
    officials_json
  end

  def self.fetch_all_for_address(address)
    full_url = URI(self::OFFICIALS_URL + "&address=#{address}")
    data = Net::HTTP.get(full_url)
    self.process_officials(data)
  end
end
