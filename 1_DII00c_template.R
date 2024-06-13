install.packages("here")
library(here)

Sys.setenv(JAVA_OPTS = "-Xmx8g")
options(digits = 22)

year <- 2024
Q <- 1
base_path <- here("F:/.../.../DII00c")

# 1. Šablonam izmanto iepriekšējā ceturkšņa gala failu.
if(Q == 1) {
  fileName <- paste0("template_DII00c_2000_", year-1, "Q4")
} else {
  fileName <- paste0("template_DII00c_2000_", year, "Q", Q-1)
}

DII00c_path <- here(base_path, "DB_fails", "DII00c.csv")
DII00c <- read.table(DII00c_path, sep = ";")
assign(fileName, DII00c)
rm(DII00c)

# 2. Noformē
x <- get(fileName)
rm(list = fileName)
colnames(x) <- x[1, ]
x <- x[-1, ]
rownames(x) <- NULL

# 2. Izveido rindu aili un rindu vektoru, pēc kura šo tabulu varēs savākt kopā
x$rindas <- paste0(x$TIME, x$INDICATOR, x$SESON, x$NACE)
row_order1 <- x$rindas

# 3. Izveido aiļu vektorus, pēc kuras pēcāk šo tabulu savākt kopā
ailes_order <- colnames(x)

# 4. Saglabā
save_dir <- here(base_path, year, paste0("Q", Q), "izstrade", "intermediate_tables", "starting_templates")
save_path <- file.path(save_dir, paste0("1_", fileName, ".RData"))
assign(fileName, x)
rm(x)

save(list = fileName, file = save_path)
rm(list = fileName)

row_order_path <- file.path(save_dir, "1_rindas.RDS")
saveRDS(row_order1, file = row_order_path)
rm(row_order1)

ailes_order_path <- file.path(save_dir, "1_ailes.RDS")
saveRDS(ailes_order, file = ailes_order_path)
rm(ailes_order, fileName)
