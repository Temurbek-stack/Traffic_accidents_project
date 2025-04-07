merged_streets2 <- st_read("G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/merged_tashkent_streets_utm_projection.shp")

# Segmentize streets into 1km segments
merged_streets2 <- merged_streets2 %>%
  mutate(geometry = st_segmentize(geometry, units::set_units(1, km)))

# Split each street into LINESTRINGs and create a data frame for each
split_streets <- lapply(1:nrow(merged_streets2), function(i) {
  street_id <- merged_streets2$street_id[i]
  street_segments <- st_cast(merged_streets2[i, ], "LINESTRING")
  data.frame(street_id = rep(street_id, nrow(street_segments)),
             geometry = st_as_sfc(street_segments),
             stringsAsFactors = FALSE)
})

# Combine all data frames into one
streets_segmentized_df <- do.call(rbind, split_streets)
streets_segmentized_df <- streets_segmentized_df %>%
  group_by(street_id) %>%
  mutate(segment_id = paste0(street_id, row_number()))

# merge street_name_latin
merged_df <- left_join(merged_streets2, streets_segmentized_df, by = "street_id")
merged_df <- merged_df %>%
  rename(geometry = geometry.y)
merged_df$geometry.x <- NULL

merged_df_unique <- merged_df %>%
  distinct(geometry, .keep_all = TRUE)
# Convert to an sf object
streets_segmentized_sf <- st_as_sf(merged_df, sf_column_name = "geometry")



st_write(streets_segmentized_sf, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/segmentized_tashkent_streets_utm_projection_python.shp", layer_options = "ENCODING=UTF-8")


linestrings <- st_cast(merged_streets2, "LINESTRING")



# Attempt to combine LINESTRINGs into a single LINESTRING
# This assumes the LINESTRINGs are spatially connected
single_linestring <- linestrings %>% 
  group_by(name_latin) %>%   # Replace with an appropriate grouping variable, if any
  summarise(geometry = st_union(geometry), do_union = TRUE) %>% 
  st_cast("LINESTRING")


st_write(single_linestring, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/single_linestring_merged_tashkent_streets.shp", layer_options = "ENCODING=UTF-8")
