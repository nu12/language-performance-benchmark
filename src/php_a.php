<?php 

$current_value = 0.00;
$highest = 0.00;
$sum = 0.00;
$count = 0;
$input = fopen("db/database.dat", "r");
$output = fopen("outputs/php_a.csv", "a");

while (($line = fgets($input)) !== false) {
    $current_value = floatval($line);
    if ($current_value > $highest) {
        $highest = $current_value;
    }
    $sum = $sum + $current_value;
    $count = $count + 1;
}
fclose($input);


fwrite($output, "$highest,$sum,$count");
fclose($output);

?>