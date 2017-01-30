class Jobler::Jobler < ActiveRecord::Base
  has_many :results, dependent: :destroy
end
