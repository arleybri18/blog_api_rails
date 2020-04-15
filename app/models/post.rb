class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :published, inclusion: {in: [true, false]} # se usa inclusion en vez de presence, para validar que se permita alguno de los dos
  validates :user_id, presence: true
end
