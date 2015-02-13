# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042
s = Style.create(name:"Lager")

b1.beers.create name:"Iso 3", style:s
b1.beers.create name:"Karhu", style:s
b1.beers.create name:"Tuplahumala", style:s
b2.beers.create name:"Huvila Pale Ale", style:s
b2.beers.create name:"X Porter", style:s
b3.beers.create name:"Hefezeizen", style:s
b3.beers.create name:"Helles", style:s


#b1.beers.each{|x| x.ratings.create(score:(1 + rand(50)))}
#b2.beers.each{|x| x.ratings.create(score:(1 + rand(50)))}
#b3.beers.each{|x| x.ratings.create(score:(1 + rand(50)))}
