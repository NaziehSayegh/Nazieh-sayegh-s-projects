import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class CitiesReportPanel extends JPanel {
    private JRadioButton cityRadioButton;
    private JRadioButton countRadioButton;
    private JTextField inputTextField;
    private JButton generateButton;

    public CitiesReportPanel() {
        setLayout(new GridLayout(4, 1));

        cityRadioButton = new JRadioButton("City");
        countRadioButton = new JRadioButton("Count");
        inputTextField = new JTextField();
        generateButton = new JButton("Generate Report");

        ButtonGroup radioButtonGroup = new ButtonGroup();
        radioButtonGroup.add(cityRadioButton);
        radioButtonGroup.add(countRadioButton);

        add(cityRadioButton);
        add(countRadioButton);
        add(inputTextField);
        add(generateButton);

        generateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                generateReport();
            }
        });
    }

    private void generateReport() {
        String input = inputTextField.getText().trim();
        if (input.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter a city name or count.");
            return;
        }

        List<String> cities = getCitiesFromCSV();

        if (cityRadioButton.isSelected()) {
            String city = input;
            if (!cities.contains(city)) {
                JOptionPane.showMessageDialog(this, "City not found.");
                return;
            }
            generateCityReport(city);
        } else if (countRadioButton.isSelected()) {
            int count;
            try {
                count = Integer.parseInt(input);
            } catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(this, "Invalid count.");
                return;
            }
            generateCountReports(cities, count);
        }
    }

    private List<String> getCitiesFromCSV() {
        List<String> cities = new ArrayList<>();
        try {
            File file = new File("USACities.csv");
            Scanner scanner = new Scanner(file);
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] parts = line.split(",");
                if (parts.length >= 1) {
                    String city = parts[0];
                    cities.add(city);
                }
            }
            scanner.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return cities;
    }

    private void generateCityReport(String city) {
        try {
            File file = new File(city + ".txt");
            FileWriter writer = new FileWriter(file);
            writer.write("City: " + city + "\n");

            // Retrieve data from CSV based on city
            try {
                File csvFile = new File("USACities.csv");
                Scanner scanner = new Scanner(csvFile);
                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine();
                    String[] parts = line.split(",");
                    if (parts.length >= 5 && parts[0].equals(city)) {
                        String state = parts[1];
                        int population2021 = Integer.parseInt(parts[2]);
                        int population2010 = Integer.parseInt(parts[3]);
                        double area = Double.parseDouble(parts[4]);
                        double density2021 = population2021 / area;
                        double density2010 = population2010 / area;
                        double growthRate = (double) (population2021 - population2010) / population2010;

                        writer.write("City: " + city + " (" + state + ")\n");
                        writer.write("Population in 2021: " + population2021 + "\n");
                        writer.write("Population in 2010: " + population2010 + "\n");
                        writer.write("Area: " + area + "\n");
                        writer.write("Density in 2021: " + density2021 + "\n");
                        writer.write("Density in 2010: " + density2010 + "\n");
                        writer.write("Growth rate: " + growthRate + "\n");

                        break;
                    }
                }
                scanner.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void generateCountReports(List<String> cities, int count) {
        int actualCount = Math.min(count, cities.size());
        for (int i = 0; i < actualCount; i++) {
            String city = cities.get(i);
            generateCityReport(city);
        }
    }
}

