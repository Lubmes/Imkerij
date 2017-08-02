class Run < ApplicationRecord
  belongs_to :delivery
  belongs_to :invoice
end
