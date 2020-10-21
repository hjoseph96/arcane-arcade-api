class V1::CategoriesController < ApiController
  def index
    @categories = Category.all

    render_success(data: serialized_category)
  end

  private

  def serialized_category
    CategorySerializer.new(@categories || @category).serializable_hash
  end
end
