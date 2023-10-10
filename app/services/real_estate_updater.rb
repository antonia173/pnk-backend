class RealEstateUpdater
  def initialize(real_estate, real_estate_params)
    @real_estate = real_estate
    @real_estate_params = real_estate_params.except(:realEstateType, :content)
    @type_params = real_estate_params[:realEstateType]
    @content_params = real_estate_params[:content]
    
    perform
  end

  def perform
    begin
      real_estate_update
      type_update
      content_update
    rescue => e
      raise "Update real estate error: #{e.message}"
    end
  end

  private

  def real_estate_update
    @real_estate.update!(@real_estate_params)
  end

  def type_update
    return unless @type_params.present?
    type = RealEstateType.find_by(name: @type_params[:typeName])
    @real_estate.update!(real_estate_type: type)
  end

  def content_update
    content_delete
    content_update_or_create
  end

  # updating real_estate user can delete existing content
  def content_delete
    contents = @real_estate.real_estate_contents
    # reject contents that are included in @content_params and @real_estate.real_estate_contents
    missing_contents = contents.reject { |c| @content_params.any? { |cp| cp[:contentName] == c.name } }
    missing_contents.each(&:destroy)  if missing_contents.present?
  end

  # updating real_estate user can add new content or update existing content
  def content_update_or_create
    @content_params.each do |cp|
      if content = RealEstateContent.find_by(real_estate_id: @real_estate.id, name: cp[:contentName])
        content.update!(cp)
      else
        content = RealEstateContent.new(cp)
        content.real_estate_id = @real_estate.id 
        content.save!
      end
    end
  end

end
  