path <- file.path(base_path, paste0(year, "Q", Q))

# 1. Ielādē šablonu
template_path <- file.path(path, "izstrade", "intermediate_tables", "starting_templates")
load(file.path(template_path, paste0("template_DII00c_2000_", year, "Q", Q, ".RData")))

s <- get(paste0("template_DII00c_2000_", year, "Q", Q))
rm(list = paste0("template_DII00c_2000_", year, "Q", Q))

# 2. Sadali NSA un SA apakštabulās
s$SESON <- factor(s$SESON)

s_split <- split(s, s$SESON)
list2env(s_split, envir = .GlobalEnv)
rm(s, s_split)

# 3. Saglabā apakštabulas
intermediate_path <- file.path(path, "izstrade", "intermediate_tables")
save(NSA, file = file.path(intermediate_path, "NSA.RData"))
rm(NSA)

save(SA, file = file.path(intermediate_path, "SA.RData"))
rm(SA)
