class AddSupportedLanguagesToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :supported_languages, :jsonb
  end
end
