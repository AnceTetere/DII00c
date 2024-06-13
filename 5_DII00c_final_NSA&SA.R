#----------------Izstrādā NSA un SA
#path <- file.path(base_path, paste0(year, "Q", Q))
c <- c("NSA", "SA")

for (i in 1:length(c)) {

#1. Ielādē šablonu
template_path <- file.path(path, "izstrade", "intermediate_tables", paste0(c[i], ".RData"))
load(template_path)
assign("t", get(c[i]))
rm(list = c[i])
t$forMerge <- paste0(t$TIME, "_", t$NACE)

#2. Ielādē ceturkšņa indeksus
data_path <- file.path(paste0("F:/.../ICL/forEurostat/", year, "ICL", year, "_Q", Q, "/workflow/2_Fails_Eurostatam/sagatavošana/intermediate_tables"))
if(c[i] == "NSA") {
  load(paste0("F:\\...\\ICL\\forEurostat\\", year, "\\ICL",
            year, "_Q", Q, "\\workflow\\2_Fails_Eurostatam\\sagatavošana\\intermediate_tables\\gatavs_nsaICL_00Q1_",
            substr(year, 3, 4), "Q", Q, ".RData"))
  } else {
    load(paste0("F:\\...\\ICL\\forEurostat\\", year, "\\ICL",
              year, "_Q", Q, 
              "\\workflow\\2_Fails_Eurostatam\\sagatavošana\\intermediate_tables\\gatavs_saICL_00Q1_", 
              substr(year, 3, 4), "Q", Q, ".RData"))}

d <- get(paste0(tolower(c[i]), "ICL_00Q1_", substr(year, 3, 4), "Q", Q))
rm(list = paste0(tolower(c[i]), "ICL_00Q1_", substr(year, 3, 4), "Q", Q))


#3. No ICL datu tabulas izņemt NACE agregātus B-N un O-S
d <- d[!d$ACTIVITY %in% c("BTN", "OTS"), ] #7220
d$ACTIVITY[d$ACTIVITY == "BTS"] <- "B-S"

# Savienošanas aile
d$forMerge <- paste0(substr(d$TIME_PERIOD, 1, 4), 
                          substr(d$TIME_PERIOD, 6, 7), "_", d$ACTIVITY)

# No nsaICL izņem indikatoru “TXB un izdala ailes
d <- d[d$INDICATOR != "ICL_TXB", ] 

testV <- switch(
  c[i],
  "NSA" = "N",
  "SA" = "Y"
)

if(sum(d$SEASONAL_ADJUST == testV) == nrow(d) & sum(t$forMerge %in% d$forMerge) == nrow(d)) {
  d <- d[ , c("INDICATOR", "OBS_VALUE", "forMerge")]
} else {
  print("Te visi atzīmētie dati ir sezonāli izkoriģēti.")
}
rm(testV)

#5. Sadala šablonu pa INDICATOR
t$INDICATOR <- factor(t$INDICATOR)

T_split <- split(t, t$INDICATOR)
names(T_split) <- paste0(c[i], "_", names(T_split))
temp_T <- names(T_split)
list2env(T_split, envir = .GlobalEnv)
rm(T_split, t)

#6. Sadala ICL datus
d$INDICATOR <- factor(d$INDICATOR)

D_split <- split(d, d$INDICATOR)
names(D_split) <- paste0(tolower(c[i]), "_", names(D_split))
list2env(D_split, envir = .GlobalEnv)
rm(D_split, d)

#7. Datu savienošanas funkcija
for(j in 1:length(temp_T)) {
  x1 <- temp_T[j]
  
  x2 <- ifelse(
    x1 == paste0(c[i], "_LC_OTH"),
    paste0(tolower(c[i]), "_ICL_O"),
    ifelse(
      x1 == paste0(c[i], "_LC_TOTAL"),
      paste0(tolower(c[i]), "_ICL_T"),
      ifelse(
        x1 == paste0(c[i], "_LC_WAG_TOT"),
        paste0(tolower(c[i]), "_ICL_WAG"),
        print("Nepareizs tabulas nosaukums vektorā.")
      )
    )
  )
  
  
  mergedDF <- merge(get(x1), get(x2)[ , c("OBS_VALUE", "forMerge")], by.x = "forMerge", by.y = "forMerge")
  mergedDF$I2020 <- mergedDF$OBS_VALUE
  mergedDF$OBS_VALUE <- NULL
  mergedDF$forMerge <- NULL
  assign(paste0("gatavs_", j), mergedDF)
  rm(list = c(x1, x2), mergedDF, x1, x2)
}
rm(j, temp_T)

#8. Sašuj gatavās tabulas kopā un noglabā
y <- rbind(gatavs_1, gatavs_2, gatavs_3)
rm(gatavs_1, gatavs_2, gatavs_3)

assign(paste0("gatavs_", c[i]), y)
intermediate_path <- file.path(path, "izstrade", "intermediate_tables")
save(list = paste0("gatavs_", c[i]), file = paste0("gatavs_", c[i], "00Q1_", substr(year, 3, 4), "Q", Q, ".RData"))

rm(list = paste0("gatavs_", c[i]), y)
}
rm(c, i)
