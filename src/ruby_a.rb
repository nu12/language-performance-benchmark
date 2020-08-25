current_value = 0
highest = 0
sum = 0
count = 0
input = File.open("db/database.dat", "r")
output = File.open("outputs/ruby_a.csv", "a")

input.each_line do |line|
    current_value = line.to_f
    if current_value > highest
        highest = current_value
    end
    sum = sum + current_value
    count = count + 1
end
input.close

output.write("#{highest},#{sum},#{count}")
output.close