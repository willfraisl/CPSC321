/*
 * Will Fraisl
 * Homework 10
 * 11/27/18
 */

import java.sql.*;
import java.util.Scanner;

public class HW10 {
    public static void main(String[] args) throws Exception {
        // set up scanner
        Scanner reader = new Scanner(System.in);

        // create connection
        String url = "jdbc:mysql://cps-database.gonzaga.edu/bowersBD";
        String user = "username";
        String pass = "password";
        Connection con = DriverManager.getConnection(url, user, pass);
        Statement st = con.createStatement();

        // menu loop
        while(true) {
            System.out.println("\n1. List countries");
            System.out.println("2. Add country");
            System.out.println("3. Find countries based on gdp and inflation");
            System.out.println("4. Update country’s gdp and inflation");
            System.out.println("5. Exit");
            System.out.print("Enter your choice (1-5): ");
            int choice = reader.nextInt();
            System.out.println();

            switch (choice) {
                case 1:
                    // create a statement and execute it
                    String query = "SELECT * FROM country";
                    ResultSet rs1 = st.executeQuery(query);
                    // print result
                    while(rs1.next()) {
                        String code = rs1.getString("code");
                        String country_name = rs1.getString("country_name");
                        System.out.println(country_name + " (" + code + ")");
                    }
                    rs1.close();
                    break;
                case 2:
                    // get input
                    reader.nextLine();
                    System.out.println("Country code:");
                    String code = reader.nextLine();
                    System.out.println("Country name:");
                    String country_name = reader.nextLine();
                    System.out.println("Country per capita gdp (USD):");
                    int gdp = reader.nextInt();
                    System.out.println("Country inflation (pct):");
                    float inflation = reader.nextFloat();

                    //check if code already exists
                    query = "SELECT code FROM country WHERE code = '" + code + "'";
                    ResultSet rs2 = st.executeQuery(query);

                    // if code does not exist, add to database
                    if(!rs2.first()){
                        query = "INSERT INTO country VALUES ('"+code+"','"+country_name+"',"+gdp+","+inflation+")";
                        PreparedStatement ps = con.prepareStatement(query);
                        ps.execute();
                    }

                    //if code does exist tell user
                    else{
                        System.out.println("That country code already exists");
                    }
                    rs2.close();
                    break;
                case 3:
                    // get input
                    reader.nextLine();
                    System.out.println("Number of countries to display:");
                    int num = reader.nextInt();
                    System.out.println("Minimum per capita gdp (USD):");
                    int minGdp = reader.nextInt();
                    System.out.println("Maximum inflation (pct):");
                    float maxInflation = reader.nextFloat();
                    System.out.println();

                    //execute query
                    query = "SELECT code, country_name, gdp, inflation FROM country WHERE gdp >= "+minGdp+" AND inflation <= "+maxInflation+" ORDER BY gdp DESC, inflation LIMIT "+num;
                    ResultSet rs3 = st.executeQuery(query);
                    while(rs3.next()) {
                        String code3 = rs3.getString("code");
                        String country_name3 = rs3.getString("country_name");
                        int gdp3 = rs3.getInt("gdp");
                        float inflation3 = rs3.getFloat("inflation");
                        System.out.println(country_name3 + " (" + code3 + "), "+gdp3+", "+inflation3);
                    }
                    rs3.close();
                    break;
                case 4:
                    // get input
                    reader.nextLine();
                    System.out.println("Country code:");
                    String code4 = reader.nextLine();
                    System.out.println("Country per capita gdp (USD):");
                    int gdp4 = reader.nextInt();
                    System.out.println("Country inflation (pct):");
                    float inflation4 = reader.nextFloat();

                    //check if code already exists
                    query = "SELECT code FROM country WHERE code = '" + code4 + "'";
                    ResultSet rs4 = st.executeQuery(query);

                    // if code does not exist, tell the user
                    if(!rs4.first()){
                        System.out.println("That country code doesn't exist");
                    }

                    //if code does exist, update the database
                    else{
                        query = "UPDATE country SET gdp = "+gdp4+", inflation = "+inflation4+" WHERE code = '"+code4+"'";
                        PreparedStatement ps4 = con.prepareStatement(query);
                        ps4.execute();
                    }
                    rs4.close();
                    break;
                default:
                    st.close();
                    con.close();
                    System.exit(0);
            }
        }
    }
}