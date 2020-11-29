class CreateCurrencyConversions < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_conversions do |t|
      t.jsonb :usd, null: false, default: {}
      t.jsonb :eur, null: false, default: {}
      t.jsonb :jpy, null: false, default: {}
      t.jsonb :gbp, null: false, default: {}
      t.jsonb :aud, null: false, default: {}
      t.jsonb :cad, null: false, default: {}
      t.jsonb :chf, null: false, default: {}
      t.jsonb :cny, null: false, default: {}
      t.jsonb :sek, null: false, default: {}
      t.jsonb :nzd, null: false, default: {}

      t.timestamps
    end
  end
end
