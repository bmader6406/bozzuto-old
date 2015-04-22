class PropertyFeaturesPage < PropertyPage
  def features
    [].tap do |features|
      (1..3).each do |i|
        if public_send("title_#{i}").present?
          features << OpenStruct.new(
            :title => public_send("title_#{i}"),
            :text  => public_send("text_#{i}")
          )
        end
      end
    end
  end
end
