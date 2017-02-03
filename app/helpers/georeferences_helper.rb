module GeoreferencesHelper

  # Needs to turn into a gmap with the item displayed
  def georeference_tag(georeference)
    return nil if georeference.nil?
    georeference.id.to_s
  end

  def get_gr(gr_result)
    return gr_result[:gr]
  end

  def get_result(gr_result)
    return gr_result[:valid?]
  end

end
