class BoosterPack < ActiveRecord::Base
  belongs_to :subscription_plan
  composed_of :price, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency)]
end
