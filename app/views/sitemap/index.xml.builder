xml.instruct!
xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9",
           "xmlns:xsi"=> "http://www.w3.org/2001/XMLSchema-instance",
           "xsi:schemaLocation"=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") do
  @pages.each do |page|
    xml.url do
      xml.loc page
    end
  end

  @active_record_objects.each do |type, objects|
    objects.each do |object|
      xml.url do
        xml.loc send(type.to_s + '_url', object)
        xml.lastmod object.updated_at.to_date.to_s(:db)
      end
    end
  end
end