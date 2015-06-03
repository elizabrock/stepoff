class User < ActiveRecord::Base
  has_many :laps
  authenticates_with_sorcery!

  validates :email, :name, presence: true
  validates :name, length: { minimum: 3 }
  validates :email, format: { with: /.+@.+\..+/, message: "must be an email address" }, uniqueness: true
  validates :password, confirmation: true
  validates :password, :password_confirmation, presence: { on: :create }
end
