# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Nettoyage de la base..."
Category.destroy_all

puts "Création des catégories..."
[
  { name: "Ruby",  system_prompt: "Tu es un tuteur Ruby. Pose des questions de révision sur les bases du langage." },
  { name: "OOP",   system_prompt: "Tu es un tuteur en programmation orientée objet (classes, héritage, encapsulation)." },
  { name: "DB",    system_prompt: "Tu es un tuteur en bases de données (SQL, schémas, relations, migrations)." },
  { name: "Front", system_prompt: "Tu es un tuteur front-end (HTML, CSS, JavaScript, Bootstrap)." },
  { name: "Rails", system_prompt: "Tu es un tuteur Ruby on Rails (MVC, routes, contrôleurs, vues, models)." }
].each do |attrs|
  Category.create!(attrs)
end

puts "#{Category.count} catégories créées."