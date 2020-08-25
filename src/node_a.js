const fs = require('fs');

fs.readFile('db/database.dat', 'utf8', function(err, data) {
    current_value = 0;
    highest = 0;
    sum = 0;
    count = 0;
    data = data.split("\n");

    for (i = 0; i < data.length; i++) {
        current_value = data[i];
        current_value = parseFloat(data[i]);
        if (Number.isNaN(current_value) != true){
            if(current_value > highest){
                highest = current_value;
            }
            sum = sum + current_value;
            count = count + 1;
        }
    }
    fs.appendFile('outputs/node_a.csv', highest + "," + sum + "," + count ,  function (err){})
});