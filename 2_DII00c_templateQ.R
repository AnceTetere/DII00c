#-------- IZVEIDO CETURKŠŅA ŠABLONU-------

#1. Ceturkšņa šablonu veido no iepriekšējajā solī izveidotā lielā šablona.
setwd(paste0(path, "\\izstrade\\intermediate_tables\\starting_templates"))

if(Q == 1) {
  fileName <- paste0("template_DII00c_2000_", year-1, "Q4")
} else {
  fileName <- paste0("template_DII00c_2000_", year, "Q", Q-1)
}

load(paste0("1_", fileName, ".RData"))
y <- get(fileName)
rm(list = fileName, fileName)

#2. Atlasa pēdējo ceturksni

if(Q == 1) {
  y <- y[y$TIME == paste0(year-1, "Q4"), ]
} else {
  y <- y[y$TIME == paste0(year, "Q", Q-1), ] 
} #114

#3. Sakārto to
rownames(y) <- NULL
y$TIME <- paste0(year, "Q", Q)
y$I2020 <- ""
y$I2020_X <- ""
y$PCH_SAME <- ""
y$PCH_SAME_X <- ""

#4. Izveido rindu aili jaunajam ceturksnim un, attiecīgi, vektoru tam.
y$rindas <- paste0(y$TIME, y$INDICATOR, y$SESON, y$NACE)
row_order2 <- y$rindas

#5. Uzreiz izveido gala faila rindu vektoru
row_order1 <- readRDS("1_rindas.RDS")
row_order <- append(row_order1, row_order2)
rm(row_order1)

#6. Saglabā ceturkšņa šablonu un rindas
fileName <- paste0("templateQ_DII00c_", year, "Q", Q)
assign(fileName, y)
rm(y)

save(list = fileName, file = paste0("2_", fileName, ".RData"))
rm(list = fileName, fileName)

saveRDS(row_order2, file = "2_rindas.RDS")
rm(row_order2)

saveRDS(row_order, file = "Rindas_kopa.RDS")
rm(row_order)

setwd(path)
