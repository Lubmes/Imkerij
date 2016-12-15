class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :orders, foreign_key: "customer_id"
  has_many :deliveries

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
end
