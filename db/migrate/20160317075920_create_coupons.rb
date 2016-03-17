class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :openid
      t.datetime :start_time
      t.datetime :end_time
      t.float :price

      t.timestamps null: false
    end
  end
end
