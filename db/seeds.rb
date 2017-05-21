User.create(email: ENV["admin_email"], password: ENV["admin_password"], is_admin: true)

url = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=#{ENV["api-key"]}"
response = HTTParty.get(url)

#Iterates through the response to create a champion object for each
response["data"].sort.each do |champ|
  Champion.create!(name: champ[1]["name"],
   key: champ[1]["key"].titleize,
   riot_id: champ[1]["id"],
   title: champ[1]["title"],
   lore: champ[1]["lore"],
   img: champ[1]["image"]["full"],
   attack: champ[1]["info"]["attack"],
   defense: champ[1]["info"]["defense"],
   magic: champ[1]["info"]["magic"],
   difficulty: champ[1]["info"]["difficulty"])

   champ[1]["spells"].reverse.each do |spell|
     Ability.create(name: spell["name"],
     description: spell["sanitizedDescription"],
     image: spell["image"]["full"],
     champion_id: Champion.find_by(riot_id: champ[1]["id"]).id)
   end

   champ[1]["skins"].each do |skin|
     Skin.create(name: skin["name"],
     num: skin["num"],
     champion_id: Champion.find_by(riot_id: champ[1]["id"]).id)
   end

end

#help me im drowning in json
