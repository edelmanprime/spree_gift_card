Spree::StoreController.class_eval do

  protected

    def apply_gift_code
      if params[:order] && params[:order][:gift_code]
        @order.gift_code = params[:order][:gift_code]
      end
      return true if @order.gift_code.blank?
      if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
        gift_card.apply(@order)

        if @order.payment? && !@order.payment_required?
          if params[:order]
            # Delete payment params so a payment won't be created
            params[:order].delete(:payments_attributes)
            params.delete(:payment_source)
          end
        end

        flash[:success] = Spree.t(:gift_code_applied)
      else
        flash.now[:error] = Spree.t(:gift_code_not_found)
        respond_with(@order) { |format| format.html { render :edit } } and return
      end
    end

end
