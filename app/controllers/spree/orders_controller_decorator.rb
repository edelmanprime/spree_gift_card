Spree::OrdersController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  before_action :apply_gift_code, only: :update

end
