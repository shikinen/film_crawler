require 'mechanize'

agent = Mechanize.new

filmweb = agent.get "https://filmweb.pl"
movie_ranking = filmweb.link_with(text: "ranking top 500").click

rows = movie_ranking.root.css(".ranking__list div.item")

movie_data = rows.take(10).inject({}) do |hash, row|
    title = row.at_css("div.film h3.film__title a").text.strip
    rating = row.at_css("div.film div.place__extras span.rate__value").text.strip.sub(/,/,".").to_f
    year = row.at_css("div.film h3.film__title .film__production-year").text.strip[1..-2].to_i
    votes = row.at_css("div.film div.place__extras span.rate__count").text.strip.match(/\d+\s+\d+/).to_s
    hash[title] = [rating, year, votes]
    hash
end

puts movie_data
