class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.string :url
      t.string :request_type, limit: 15
      t.text :request
      t.text :response

      t.timestamps
    end
  end
end
