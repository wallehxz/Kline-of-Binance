class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.integer  :chain_id
      t.float    :total
      t.float    :bulk
      t.float    :procure
      t.boolean  :fettle
    end
  end
end
