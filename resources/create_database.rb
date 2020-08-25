File.open("db/database.dat", "w") do | file |
    (ARGV[0].to_i||1000000).times do
        v = "#{sprintf('%.2f', rand * 1000000)}"
        while v.size < 10 do
            v.prepend(" ")
        end
        file.puts(v)
    end
end