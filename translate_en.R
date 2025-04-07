setwd("G:/Meine Ablage/Data_solutions/Traffic accidents/Traffic accidents_new")
#setwd("D:/ELDOR/PROJECTS/LINK DATA/PROJECTS/Traffic Accidents")

#dataset_clean <- readRDS("dataset_clean.rds")
#data_c <- readRDS("data_c.rds")
merged_data_sf <- readRDS("merged_data_sf.rds")
merged_data_sf_p <- readRDS("merged_data_sf_p.rds")
merged_data_sf_t <- readRDS("merged_data_sf_t.rds")
dataset_clean <- readRDS("dataset_clean.rds")
data_c <- readRDS("data_c.rds")

merged_data_sf$name_en <- google_translate(merged_data_sf$name_latin, target_language = "en", source_language = "uz")
saveRDS(merged_data_sf, file = "merged_data_sf_translated.rds")
merged_data_sf_t$name_en <- google_translate(merged_data_sf_t$name_latin, target_language = "en", source_language = "uz")
saveRDS(merged_data_sf_t, file = "merged_data_sf_t_translated.rds")

merged_data_sf_p$name_en <- google_translate(merged_data_sf_p$name_latin, target_language = "en", source_language = "uz")
saveRDS(merged_data_sf_p, file = "merged_data_sf_p_translated.rds")


# Named vector of translations
age_group_translation <- c(
  "10-18 yoshlar" = "10–18 years",
  "18-29 yoshlar" = "18–29 years",
  "30-39 yoshlar" = "30–39 years",
  "40-49 yoshlar" = "40–49 years",
  "50-59 yoshlar" = "50–59 years",
  "60-69 yoshlar" = "60–69 years",
  "70-79 yoshlar" = "70–79 years",
  "80-90 yoshlar" = "80–90 years"
)

# Apply to your dataframe
data_c$age_segments_en <- age_group_translation[data_c$age_segments]
saveRDS(data_c, file = "data_c_translated.rds")


# Create a named vector for translation
translation_dict <- c(
  "piyodani urib yuborish" = "hitting a pedestrian",
  "to'qnashuv" = "collision",
  "to'siqqa urilish" = "crashing into an obstacle",
  "turgan TVga urilish" = "hitting a parked vehicle",
  "velosipedchini urib yuborish" = "hitting a cyclist",
  "YTHning boshqa turlari" = "other types of accidents",
  "ag'darilish" = "overturning",
  "ot-aravani urib yuborish" = "hitting a horse cart",
  "hayvonni urib yuborish" = "hitting an animal"
)

# Map the translations to a new column
dataset_clean$accident_type_name_en <- translation_dict[dataset_clean$accident_type_name_uz]

# Create a named vector for translations
violation_translation1 <- c(
  "toʼxtash va toʼxtab turish" = "stopping and parking",
  "yo'l belgilari, chiziqlariga rioya qilmaslik" = "disregarding road signs and lane markings",
  "qarama-qarshi yoʼnalish, chiqish, quvib oʼtish" = "wrong-way driving, exiting, overtaking",
  "boshqa qoidabuzarlik" = "other violation",
  "svetoforga rioya qilmaslik" = "disregarding traffic lights",
  "belgilangan tezlikka rioya qilmaslik" = "speeding",
  "oraliq masofani saqlamaslik" = "not keeping safe distance",
  "yoʼnalishni oʼzgartirish" = "improper lane changing",
  "TVni mast holda boshqarish" = "driving under the influence",
  "chorraxadan oʼtish" = "intersection violation",
  "uyali telefondan foydalanish" = "using a mobile phone while driving",
  "charchoqlik, rulda uxlab qolish" = "fatigue, falling asleep at the wheel",
  "belgilanmagan joydan yo'lni kesib o'tish" = "crossing at an undesignated location",
  "boshqa qoidabuzarliklar" = "other violations",
  "odam tashish" = "passenger transport violation",
  "t/y kesishmasidan oʼtish" = "railroad crossing violation",
  "yo'l belgilari, svetofor talabiga bo'yinsinmaslik" = "ignoring road signs and traffic lights",
  "monitordan foydalanish" = "using a monitor",
  "mast holatda" = "intoxicated state",
  "imtiyozga ega bulgan TVni oʼtkazib yuborish" = "failing to yield to a priority vehicle",
  "yo'l qatnov qismida o'ynashlik" = "playing on the roadway",
  "piyodalar oʼtish yoʼlqasidan oʼtish" = "improper pedestrian crossing",
  "yoritish chiroqlaridan foydalanish" = "improper use of lights",
  "umumfoydalanishdagi TV toʼxtash joyidan oʼtish" = "crossing public transport stop"
)

# Apply translations to your data frame
dataset_clean$participants_1_violation_1_name_en <- violation_translation1[dataset_clean$participants_1_violation_1_name_uz]



# Named vector: Uzbek ➜ English
violation_translation2 <- c(
  "belgilangan tezlikka rioya qilmaslik" = "speeding",
  "oraliq masofani saqlamaslik" = "not keeping safe distance",
  "yoʼnalishni oʼzgartirish" = "improper lane changing",
  "toʼxtash va toʼxtab turish" = "stopping and parking",
  "boshqa qoidabuzarlik" = "other violation",
  "boshqa qoidabuzarliklar" = "other violations",
  "qarama-qarshi yoʼnalish, chiqish, quvib oʼtish" = "wrong-way driving, exiting, overtaking",
  "chorraxadan oʼtish" = "intersection violation",
  "svetoforga rioya qilmaslik" = "disregarding traffic lights",
  "yo'l belgilari, chiziqlariga rioya qilmaslik" = "disregarding road signs and lane markings",
  "TVni mast holda boshqarish" = "driving under the influence",
  "mast holatda" = "intoxicated state",
  "yo'l belgilari, svetofor talabiga bo'yinsinmaslik" = "ignoring road signs and traffic lights",
  "yo'l qatnov qismida o'ynashlik" = "playing on the roadway",
  "7 yoshgacha bo'lgan piyoda kattalar kuzatuvisiz" = "child under 7 without adult supervision",
  "TV, daraxtlar, inshootlar orqasidan to'satdan chiqib qolishlik" = "sudden appearance from behind objects (vehicles, trees, structures)",
  "belgilanmagan joydan yo'lni kesib o'tish" = "crossing at an undesignated location"
)

# Add a new English column using the dictionary
dataset_clean$participants_2_violation_1_name_en <- violation_translation2[dataset_clean$participants_2_violation_1_name_uz]

saveRDS(dataset_clean, file = "dataset_clean_translated.rds")


