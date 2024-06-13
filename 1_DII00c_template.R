Sys.setenv(JAVA_OPTS = "-Xmx8g")
options(digits = 22)

year <- 2024
Q <- 1
path <- paste0("F:\\...\\..\\DII00c\\", year, "Q", Q, "\\")
setwd(path)

#1. Šablonam izmanto iepriekšējā ceturkšņa gala failu.
if(Q == 1) {
  fileName <- paste0("template_DII00c_2000_", year-1, "Q4")
} else {
  fileName <- paste0("template_DII00c_2000_", year, "Q", Q-1)
}

DII00c <- read.table("F:\\...\\...\\DII00c\\DB_fails\\DII00c.csv", sep = ";")
assign(fileName, DII00c)
rm(DII00c)

#2. Noformē
x <- get(fileName)
rm(list = fileName)
colnames(x) <- x[1, ]
x <- x[-1, ]
rownames(x) <- NULL

#2. Izveido rindu aili un rindu vektoru, pēc kura šo tabulu varēs savākt kopā
x$rindas <- paste0(x$TIME, x$INDICATOR, x$SESON, x$NACE)
row_order1 <- x$rindas

#3. Izveido aiļu vektorus, pēc kuras pēcāk šo tabulu savākt kopā
ailes_order <- colnames(x)

#4. Saglabā
setwd(paste0(path, "\\izstrade\\intermediate_tables\\starting_templates"))
assign(fileName, x)
rm(x)

save(list = fileName, file = paste0("1_", fileName, ".RData"))
rm(list = fileName)

saveRDS(row_order1, file = "1_rindas.RDS")
rm(row_order1)

saveRDS(ailes_order, file = "1_ailes.RDS")
rm(ailes_order, fileName)
