class Official < ActiveRecord::Base

  def self.save_officials(data)
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
end
