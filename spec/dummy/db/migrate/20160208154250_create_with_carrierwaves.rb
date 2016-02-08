class CreateWithCarrierwaves < ActiveRecord::Migration
  def change
    create_table :with_carrierwaves do |t|
      t.string :pdf
    end
  end
end
