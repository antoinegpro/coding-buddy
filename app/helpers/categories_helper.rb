module CategoriesHelper
  # Les clés doivent correspondre exactement à category.name en base
  THEMES = {
    "Ruby"  => { icon: "fa-gem",      description: "Syntaxe, méthodes et itérateurs" },
    "OOP"   => { icon: "fa-cubes",    description: "Classes, objets et héritage" },
    "DB"    => { icon: "fa-database", description: "SQL, schémas et relations", label: "Base de données" },
    "Front" => { icon: "fa-code",     description: "HTML, CSS et JavaScript", label: "Front-end" },
    "Rails" => { icon: "fa-train",    description: "MVC, routes et Active Record" }
  }.freeze

  # Valeurs par défaut pour une catégorie absente de la liste
  def category_theme(category)
    defaults = { label: category.name, icon: "fa-code", description: "" }
    defaults.merge(THEMES.fetch(category.name, {}))
  end
end
