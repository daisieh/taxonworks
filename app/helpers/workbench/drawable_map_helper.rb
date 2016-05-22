module Workbench::DrawableMapHelper

  # @param [Objects] map_objects an array of objects which know how to GeoJSON themselves
  # @param [String] border_string set to 'border="1"' if the table should have borders
  def drawable_map(map_objects, border_string = '')
    render(partial: 'layouts/map_header')
    render(partial: 'shared/data/gis/drawable_map',
           locals:  {map_objects:   map_objects,
                     border_string: border_string})
    # fail
  end

end