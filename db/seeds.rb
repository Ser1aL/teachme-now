interests_mapping = {
  culinary: %w(baking cooking drinks other),
  creative_arts: %w(photography beauty fashion interior_design film music writing crafts other),
  entrepreneurship: %w(business_development online_business marketing_and_sales culture finance law other),
  lifestyle: %w(games hobbies health home personal_development personal_finance sports travel other),
  technology: %w(mechanical_engineering electronics programming system_administration internet_media other)
}

interests_mapping.each do |interest_name, sub_interests|
  interest = Interest.find_or_create_by_name(interest_name)
  sub_interests.each do |sub_interest_name|
    interest.sub_interests.find_or_create_by_name(sub_interest_name)
  end
end