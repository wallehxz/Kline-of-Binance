class AddFailureToBills < ActiveRecord::Migration
  def change
    add_column :bills, :failure, :integer, default: 1
    add_column :bills, :cause,   :string
    add_column :bills, :genre,   :integer, default: 1
  end
end
