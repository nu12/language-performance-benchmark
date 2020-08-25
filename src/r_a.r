options(scipen=999)

current_value <- 0.0
highest <- 0.0
sum <- 0.0
count <- 0

for (line in readLines("db/database.dat")){
    current_value <- as.double(line)
    if (current_value > highest)
        highest <- current_value
    sum <- sum + current_value
    count <- count + 1
}    

sum <- formatC(sum, digits = 2, format = "f")
cat(c(highest , sum, count ),file="outputs/r_a.csv",sep=",",append=TRUE)