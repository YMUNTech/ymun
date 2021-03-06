class Character < ActiveRecord::Base
  has_many :character_committees
  has_many :committees, through: :character_committees

  has_many :seats

  belongs_to :delegation
  after_save :ensure_seats
  after_destroy :ensure_seats

  def self.unassigned(except_id = nil)
    if except_id
      where(['delegation_id IS NULL OR delegation_id = ?', except_id])
    else
      where(delegation_id: nil)
    end
  end

  def self.find_or_create_by_name(name)
    character = Character.find_by("LOWER(name) = LOWER(?)", name)
    if character.nil?
      character = Character.create(name: name)
    end
    character
  end

  def ensure_seats
    if delegation && !delegation.ensuring
      delegation.ensure_seats
    end
  end
end
