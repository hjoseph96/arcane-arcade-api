module Search
  MAX_PRICE = 60

  def search_query
    search_params[:query].present? ? search_params[:query] : "*"
  end

  def search_options
    page = search_params[:page]
    page ||= 1

    {
      page: page,
      per_page: 30,
      match: :text_middle,
      where: parse_where,
      order: parse_order
    }
  end

  private

  def parse_where
    where = {}

    min = search_params[:price_min]
    max = search_params[:price_max]

    price_search = {}

    if min.present?
      price_search[:gte] = min.to_f
    end

    if max.present? && max != MAX_PRICE
      price_search[:lte] = max.to_f
    end

    if price_search.keys.any?
      where.merge!(price: price_search)
    end

    # genre
    genre = search_params[:genre]
    if genre.present?
      where.merge!(categories: genre)
    end

    platform = search_params[:platform]
    if platform.present?
      where.merge!(supported_platforms: platform)
    end

    where
  end

  def parse_order
    case search_params[:sort_by]
    when 'release_date'
      { release_date: :desc }
    when 'name'
      { title: :asc }
    when 'price_asc'
      { price: :asc }
    when 'price_desc'
      { price: :desc }
    else
      {}
    end
  end

  def search_params
    params.permit(:page, :query, :price_min, :price_max, :genre, :platform, :sort_by)
  end
end
