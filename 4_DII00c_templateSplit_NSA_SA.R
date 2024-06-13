#1. Ielādē šablonu
setwd(paste0(path, "\\izstrade\\intermediate_tables\\starting_templates"))
load(paste0("template_DII00c_2000_", year, "Q", Q, ".RData"))

s <- get(paste0("template_DII00c_2000_", year, "Q", Q)) 
rm(list = paste0("template_DII00c_2000_", year, "Q", Q))

#2. Sadali NSA un SA apakštabulās
s$SESON <- factor(s$SESON)

s_split <- split(s, s$SESON)
list2env(s_split, envir = .GlobalEnv)
rm(s, s_split)

#3. Saglabā apakštabulas
setwd(paste0(path, "\\izstrade\\intermediate_tables"))
save(NSA, file = "NSA.RData")
rm(NSA)

save(SA, file = "SA.RData")
rm(SA)
