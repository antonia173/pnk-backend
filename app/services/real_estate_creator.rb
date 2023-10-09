class RealEstateCreator
  def initialize(real_estate_params)
    @real_estate_params = real_estate_params.except(:realEstateType, :content)
    @type_params = real_estate_params[:realEstateType]
    @contents = real_estate_params[:content]
    perform
  end

  def perform
    begin
      real_estate_create
      type_create
      contents_create
    rescue => e
      raise "Creating real estate error: #{e.message}"
    end
  end

  private

  def real_estate_create
    @real_estate = RealEstate.create!(@real_estate_params)
  end

  def type_create
    return unless @type_params.present?

    type = RealEstateType.find_or_create_by(name: @type_params[:typeName]) do |new_type|
      new_type.name = @type_params[:typeName]
      new_type.description = @type_params[:description]
    end

    @real_estate.update!(real_estate_type_id: type.id)
  end

  def contents_create
    @contents.each do |c|
      content = @real_estate.real_estate_contents.build(c)
      content.save!
    end
  end
end
  