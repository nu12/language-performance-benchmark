package main

import (
    "bufio"
    "strconv"
    "log"
    "os"
    "strings"
    
)

func main() {
	input, err := os.Open("db/database.dat")
	output, err := os.OpenFile("outputs/go_a.csv",os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)	
    if err != nil { log.Fatal(err)}
	defer input.Close()
    defer output.Close()
    
    highest := 0.0
    sum := 0.0
    count := 0

    scanner := bufio.NewScanner(input)
    for scanner.Scan() {
        current_value, err := strconv.ParseFloat(strings.TrimSpace(scanner.Text()), 32)
        if err != nil { log.Fatal(err)}
        if (current_value > highest){
            highest = current_value
        }
        sum = sum + current_value
        count = count + 1

    }
	output.WriteString(strconv.FormatFloat(highest, 'f', 2, 32) + "," + strconv.FormatFloat(sum, 'f', 2, 64) + "," + strconv.Itoa(count))
	
}
