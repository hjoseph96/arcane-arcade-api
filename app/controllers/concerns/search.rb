module Search
  def default_where
    where = {}

    min = search_params[:price_min] || 0
    max = search_params[:price_max]
    if [min, max].all?(&:present?)
      where.merge!(price: { gte: min.to_f, lte: max.to_f })
    end

    # genre
    category_id = params[:category_id]
    if category_id.present?
      where.merge!(categories: category_id)
    end


  end
end
