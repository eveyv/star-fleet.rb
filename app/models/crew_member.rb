class CrewMember < ActiveRecord::Base
  belongs_to :ships

  validates(:first_name, presence: true)
  validates(:last_name, presence: true)
  validates(:specialty, presence: true)
end
