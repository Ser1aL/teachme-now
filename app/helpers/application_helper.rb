module ApplicationHelper

  def image_tag(source, options = {})
    source ||= 'missing.jpg'
    super(source, options)
  end

end
