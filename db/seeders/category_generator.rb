class CategoryGenerator
  def self.generate!
    [
      'Free to Play',
      'Early Access',
      'Action',
      'Adventure',
      'Casual',
      'Indie',
      'Massively Multiplayer',
      'Racing',
      'RPG',
      'Simulation',
      'Sports',
      'Strategy'
    ].each_with_index do |title, i|
      category = Category.create!(title: title)

      puts "#{i + 1}. Category: '#{title}' created."
    end
  end
end
