# ---------------- NODEVUMA FORMĀTS UN PRINT-OUT

#1. Ielādē nenoformēto, galējo, pilno DII00c tabulu 
setwd(paste0(path, "\\izstrade\\intermediate_tables"))
load("finalDII00c_unformatted.RData")
x <- finalDII00c_unformatted
rm(finalDII00c_unformatted)

#2. Noformē
x$I2020 <- sprintf("%.1f", round(as.double(x$I2020), 1)) 
x$PCH_SAME <- sprintf("%.1f", round(as.double(x$PCH_SAME), 1)) 

x$PCH_SAME[x$PCH_SAME == "NA"] <- ""
x$rindas <- NULL

#3.Izprintē
DII00c_formatted <- x 
rm(x)

setwd(paste0(path, "\\izstrade\\intermediate_tables"))
save(DII00c_formatted, file = "final_DII00c_formatted.RData")
DII00c <- DII00c_formatted
rm(DII00c_formatted)

setwd(paste0(path, "\\izstrade\\printOuts"))
write.table(DII00c, "DII00c_final.csv", sep = ";", col.names = TRUE, row.names = FALSE, qmethod = "double")
rm(DII00c, path, Q, year)
