# t.string   "email",                  limit: 255, default: "", null: false
# t.string   "encrypted_password",     limit: 255, default: "", null: false
# t.string   "reset_password_token",   limit: 255
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
# t.datetime "current_sign_in_at"
# t.datetime "last_sign_in_at"
# t.string   "current_sign_in_ip",     limit: 255
# t.string   "last_sign_in_ip",        limit: 255
# t.integer  "role",                   limit: 4,   default: 1
# t.datetime "created_at"
# t.datetime "updated_at"

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
