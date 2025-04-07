library(sf)
library(dplyr)
library(leaflet)
library(lwgeom)
library(units)
library(tidyr)
library(purrr)
library(stringi)
library(stringr)

streets <- st_read("G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/tashkent_streets_shp_na_filled.shp")

streets$name_latin <- stri_trans_general(streets$name, "Russian-Latin/BGN")
streets$name_latin <- str_replace_all(streets$name_latin, "ulitsa", "ko'chasi")

## replacing the missing name_latins
streets <- streets %>%
  filter(!is.na(name_latin)) %>%
  filter(name_latin!="Amir Temur ko'chasi",
         name_latin!="Gulyor 4-tor ko'chasi",
         name_latin!="ko'chasi Mutalova",
         name_latin!="Oqtepa 7-o'tish ko'chasi",
         name_latin!="Oqtepa ko`chasi",
         name_latin!="Presidential track",
         name_latin!="Presidential Track",
         name_latin!="Qatortol 1-ko'chasi",
         name_latin!="Qoramurt koʻchasi",
         name_latin!="Rakat ko'chasi",
         name_latin!="Sodiq Tolipov 1-o'tish ko'chasi",
         name_latin!="To'rtariq ko'chasi",
         name_latin!="Toshkent yo‘li ko‘chasi",
         name_latin!="Zangiota 2-o'tish ko'chasi",
         name_latin!="Zangiota ko'chasi tupik")

## street name_latin corrections
streets <- streets %>%
  mutate(name_latin = if_else(name_latin == "Islom Karimov nom. ko'chasi", "Islom Karimov ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Юкори Каракамыш улица", "Юкори Коракамиш улица", name_latin),
         name_latin = if_else(name_latin == "Катта Канъи улица", "Катта Каъни улица", name_latin),
         name_latin = if_else(name_latin == "Aftob 1-o'tish ko'chasi", "Aftob ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Aviasozlar 1-o'tish ko'chasi", "Aviasozlar ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Cho'ponota Ko'chasi", "Cho'lpon ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Durmon yo'li", "Dombrobod ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Fayzi ko'chasi", "Fayzli ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Faziltepa Street", "Foziltepa ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Gulyor 3-o'tish ko'chasi", "Gulyor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Gulyor 5-o'tish ko'chasi", "Gulyor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Jomiy maydoni", "Jomiy ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Aerovokzalʹnaya ploshchadʹ", "Bobur ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Bogibustan ko'chasi", "Bog'ibuston ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Bogichinar ko'chasi", "Bogichinor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Bunëdkor prospekt", "Bunyodkor prospekti", name_latin),
         name_latin = if_else(name_latin == "Chimkent·skiy ko'chasi", "Chimkent ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Chimkurgon ko'chasi", "Chimqorg'on ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Chinar ko'chasi", "Chinor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Durmon yo'li ko'chasi", "Do‘rmon yo‘li ko‘chasi", name_latin),
         name_latin = if_else(name_latin == "Darë buyi ko'chasi", "Daryobo'yi ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Gayrati ko'chasi", "G'ayratiy ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Gëte ko'chasi", "Gyote ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Gulʹkhani ko'chasi", "Gulhaniy ko`chasi", name_latin),
         name_latin = if_else(name_latin == "Gulistan ko'chasi", "Guliston ko'chasi", name_latin),
         name_latin = if_else(name_latin == "ko'chasi Gulistan", "Guliston ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Husan Boyqaro ko'chasi", "Husayn Boyqaro ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Keles y·uli", "Keles yo'li", name_latin),
         name_latin = case_when(name_latin == "Katta Kanʺi ko'chasi" | name_latin == "Katta Kaʺni ko'chasi" | name_latin == "Katta Qa'ni ​ko'chasi" ~ "Katta Qa'ni ko'chasi", TRUE ~ name_latin),
         name_latin = if_else(name_latin == "Katta Ka'ni 1-o'tish ko'chasi", "Katta Qa'ni 1-o'tish ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Dombrobod ko'chasi", "Do‘rmon yo‘li ko‘chasi", name_latin),
         name_latin = if_else(name_latin == "Dombrobod ​ko'chasi", "Dombrobod ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Dombrabad ko'chasi", "Dombrobod ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Keles Yo'li 5-chi o'tish yo'li", "Keles yo'li 5-o'tish ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Khonka 5-y proyezd", "Xonqa ko'chasi", name_latin),
         name_latin = if_else(name_latin == "ko'chasi KH. Dzhurayeva", "X. Jurayev ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Kurgancha ko'chasi", "Qurg'oncha ko'chasi", name_latin),
         name_latin = case_when(name_latin == "Kurgancha ko'chasi" | name_latin == "Qurg'oncha ko'chasi" ~ "Qo'rg'oncha ko'chasi", TRUE ~ name_latin),
         name_latin = if_else(name_latin == "Lutfiy 5-chi o'tish yo'li", "Lutfiy 5-o'tish ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Makhatmy Gandi ko'chasi", "Mahatma Gandi ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Maxatma Gandi ko'chasi", "Mahatma Gandi ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Mardlik ko'chasi", "Mardlik ko‘chasi", name_latin),
         name_latin = if_else(name_latin == "Margib ko'chasi", "Margib ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Nilufar 3-tor ko'chasi", "Nilufar 1-tor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Niyëzbek y·ulli ko'chasi", "Niyozbek yo'li ko'chasi", name_latin),
         name_latin = if_else(name_latin == "OHANGARON SHOSESSI", "Ohangaron shossesi", name_latin),
         name_latin = if_else(name_latin == "ploshchadʹ Aktepe", "Muqimiy ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Polvonër ko'chasi", "Polvonyor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Qizg'aldoq ​ko'cha", "Qizg'aldoq ko'cha", name_latin),
         name_latin = if_else(name_latin == "Rakhat", "Rohat", name_latin),
         name_latin = if_else(name_latin == "ROUTE ARC-EN-CIEL", "Mirzo Ulug'bek shoh ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Sag'bon 11-chi o'tish yo'li", "Sag'bon 11-o'tish yo'li", name_latin),
         name_latin = if_else(name_latin == "Salarskiye klyuchi", "Katta Darhon ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Samarkand Darbaza ko'chasi", "Samarqand Darvoza ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Samarqand darvoza ko‘chasi", "Samarqand Darvoza ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Polvonër ko'chasi", "Sariko'l ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Sarykulʹskaya ploshchadʹ", "Polvonyor ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Sayëkhat ko'chasi", "Sayohat ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Shirin koʻchasi", "Shirin ko'chasi", name_latin),
         name_latin = case_when(name_latin == "Shifokor ko'chasi" | name_latin == "Qurg'oncha ko'chasi" ~ "Qo'rg'oncha ko'chasi", TRUE ~ name_latin),
         name_latin = if_else(name_latin == "Shifokor ko'cha", "Qizg'aldoq ko'cha", name_latin),
         name_latin = if_else(name_latin == "Shifokor ​ko'cha", "Shifokor ko'cha", name_latin),
         name_latin = if_else(name_latin == "Shifokor 1-ko'chasi", "Shifokor ko'cha", name_latin),
         name_latin = if_else(name_latin == "Shifokor ko'chasi", "Shifokorlar ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Shota Rustaveli 2-o'tish ko'chasi", "Sirg'ali yo'li shoh ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Mixail Masson ko'chasi", "Sirg'ali yo'li shoh ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Skver Amira Timura", "Amir Temur xiyoboni", name_latin),
         name_latin = if_else(name_latin == "Arnasayskaya ko'chasi", "Arnasoy ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Tashkent-Keles", "Keles yo'li", name_latin),
         name_latin = if_else(name_latin == "Uch Kakhramon ko'chasi", "Uch qahramon ko‘chasi", name_latin),
         name_latin = if_else(name_latin == "ul. Fayzully Khodzhayeva", "Fayzullaxo'jayev ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Yangishahar ko‘chasi", "Yangishahar ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Yukori Karakamysh ko'chasi", "Yukori Korakamish ko'chasi", name_latin),
         name_latin = case_when(name_latin == "Yukori Karakamysh ko'chasi" | name_latin == "Yukori Korakamish ko'chasi" | name_latin== "Yuqori qoraqamish ko'chasi" ~ "Yuqori Qoraqamish ko'chasi", TRUE ~ name_latin),
         name_latin = if_else(name_latin == "Zarqaynar ko'cha", "Zarqaynar ko'chasi", name_latin),
         name_latin = if_else(name_latin == "Zulfiyakhonim ko'chasi", "Zulfiyaxonim ko'chasi", name_latin))

# Assuming 'street_name_latin' is the column with the street name_latins
merged_streets <- streets %>%
  group_by(name_latin) %>%
  summarise(geometry = st_union(geometry))

merged_streets <- merged_streets %>%
  mutate(street_id = as.integer(factor(name_latin)))

st_write(merged_streets, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/merged_tashkent_streets.shp", layer_options = "ENCODING=UTF-8")


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



#st_write(streets_segmentized_sf, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/segmentized_tashkent_streets.shp", layer_options = "ENCODING=UTF-8")
st_write(streets_segmentized_sf, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/tashkent_streets_shapefile/segmentized_tashkent_streets_utm_projection.shp", layer_options = "ENCODING=UTF-8")

