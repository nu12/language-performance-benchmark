import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
public class java_a {    
    public static void main(String[] args) throws IOException  {
        float currentValue = 0;
        float highest = 0;
        double sum = 0;
        int count = 0;
        FileReader input = new FileReader("db/database.dat");
        FileWriter output = new FileWriter("outputs/java_a.csv", true);
        	
        BufferedReader reader = new BufferedReader(input);
        String line = reader.readLine();
        while (line != null) {
            currentValue = Float.parseFloat(line);
            if (currentValue > highest){
                highest = currentValue;
            }
            sum = sum + currentValue;
            count = count + 1;
            line = reader.readLine();
        }
        reader.close();

        output.write(String.format("%f",highest) + "," + String.format("%f",sum) + "," + String.format("%d",count));
        output.close();
    }
}
