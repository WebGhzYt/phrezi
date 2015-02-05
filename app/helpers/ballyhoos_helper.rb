module BallyhoosHelper
	def sti_ballyhoo_path(ballyhoo_type = "ballyhoo", ballyhoo = nil, action = nil)
		send "#{format_sti(action, ballyhoo_type, ballyhoo)}_path", ballyhoo
	end

	def format_sti(action, ballyhoo_type, ballyhoo)
	  action || ballyhoo ? "#{format_action(action)}#{ballyhoo_type.underscore}" : "#{ballyhoo_type.underscore.pluralize}"
	end

	def format_action(action)
	  action ? "#{action}_" : ""
	end

  def booster_audience(booster)
    if booster.audience == 0
      return 'All Patrons'
    elsif booster.audience == 1
      return 'Checked In'
    elsif booster.audience == 2
      return 'Not Checked In'
    end
  end
  
  def booster_limit_person(booster)
    if booster.limit_person.to_i == 0
      return 'Only once'
    elsif booster.limit_person.to_i == 1
      return '1 per day'
    elsif booster.limit_person.to_i == 2
      return '1 per week'
    elsif booster.limit_person.to_i == 3
      return '1 per month'
    elsif booster.limit_person.to_i == 4
      return 'Unlimited'
    end
  end

  def point_addition_or_multiplier(ballyhoo)
    if ballyhoo.point_multiplier == 0
      return 'Double'
    elsif ballyhoo.point_multiplier == 1
      return 'Triple'
    else
      return ballyhoo.point_addition
    end
  end

  def determine_product_or_category(ballyhoo)
    if ballyhoo.point_multiplier.nil? && ballyhoo.point_addition.nil?
      nil
    else
      if ballyhoo.point_multiplier.nil? && !ballyhoo.point_addition.nil?
        'Category'
      elsif !ballyhoo.point_multiplier.nil? && ballyhoo.point_addition.nil?
        'Product'
      end
    end

    # if (ballyhoo.point_multiplier == 0 || ballyhoo.point_multiplier == 1)
    #   return 'Product'
    # else
    #   return 'Category'
    # end
  end

  def product_or_category_details(ballyhoo)
    if ballyhoo.point_multiplier.nil? && ballyhoo.point_addition.nil?
      nil
    else
      if ballyhoo.point_multiplier.nil? && !ballyhoo.point_addition.nil?
        category = Category.where(id: ballyhoo.product_category).first
        if category.nil?
          'Not Available'
        else
          category.category
        end
      elsif !ballyhoo.point_multiplier.nil? && ballyhoo.point_addition.nil?
        product = MenuItem.where(id: ballyhoo.product_category).first
        if product.nil?
          'Not Available'
        else
          product.name
        end
      end
    end
  end



  def check_available_quantity(ballyhoo)
    if ballyhoo.total_checkin_qty.nil? || ballyhoo.total_checkin_qty != 'Unlimited'
      false
    else
      true
    end
  end

end