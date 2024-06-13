#--------------- SAVIENOJAM ŠABLONUS-----
# [Te patiesībā to ceturkšņā šablonu nevajag, jo jāatjauno visa laikrinda
# Tev to vajag tik vien savienošanai.]

# 1. Ielādē lielo šablonu.
if(Q == 1) {
  fileName <- paste0("template_DII00c_2000_", year-1, "Q4")
} else {
  fileName <- paste0("template_DII00c_2000_", year, "Q", Q-1)
}

load(file.path(template_path, paste0("1_", fileName, ".RData")))
X1 <- get(fileName)
rm(list = fileName, fileName)

# 2. Ielādē ceturkšņa šablonu
fileName <- paste0("templateQ_DII00c_", year, "Q", Q)
load(file.path(template_path, paste0("2_", fileName, ".RData")))
X2 <- get(fileName)
rm(list = fileName, fileName)

# 3. Savieno vienā lielajā un izformē.
X <- rbind(X1, X2)
rm(X1, X2)

X$I2020 <- ""
X$I2020_X <- ""
X$PCH_SAME <- ""

# 4. Saglabā
fileName <- paste0("template_DII00c_2000_", year, "Q", Q)
assign(fileName, X)
rm(X)

save(list = fileName, file = file.path(template_path, paste0(fileName, ".RData")))
rm(list = fileName, fileName)

# ---Es te arī aizvācu iepriekšējo šablonu, lai nesaujaucas - lai ir tikai viens, gatavais, izmantojamais.
if(Q == 1) {
  file_to_remove <- file.path(template_path, paste0("1_template_DII00c_2000_", year-1, "Q4.RData"))
} else {
  file_to_remove <- file.path(template_path, paste0("1_template_DII00c_2000_", year, "Q", Q-1, ".RData"))
}

if (file.exists(file_to_remove)) {
  file.remove(file_to_remove)
  cat(paste("Sākuma izstrādes šablons", file_to_remove, "ir izdzēsts.\n"))
} else {
  cat(paste("Sākuma izstrādes šablons", file_to_remove, "nav atrasts.\n")) # Kad ir laiks pārliec šo sarkanu.
}

file.remove(file.path(template_path, "1_rindas.RDS"), file.path(template_path, "2_rindas.RDS"))
rm(file_to_remove)
