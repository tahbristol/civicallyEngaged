class Official < ActiveRecord::Base

  def self.save_officials(data)
    json = JSON.parse(data).with_indifferent_access
    officials = json[:officials];
    division = json[:division];
    offices = json[:offices];

    officials_json = officials.map.with_index do |off, idx|
      office = offices.find {|o| o[:officialIndices].include?(idx)}

      {
        name: off[:name],
        party: off[:party],
        phone: off[:phones],
        url: off[:url],
        position: office.present? ? office[:name] : 'Unknown',
        photoUrl: off[:photoUrl]
      }
    end
    create!(officials_json)
  end
end
