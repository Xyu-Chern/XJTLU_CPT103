import java.sql.*;

public class SQLDemo {
    private static String csseURL = "jdbc:mysql://csse-mysql.xjtlu.edu.cn:3306/jianjunchen?user=JianjunChen&password=123";

    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection(csseURL);
            System.out.println("Connected to the database");
            Statement statement = conn.createStatement();

            // create two tables first
            statement.execute("DROP TABLE IF EXISTS staff, branch");
            statement.execute("CREATE TABLE branch (branchID int PRIMARY KEY, address VARCHAR(100) NOT NULL);");
            statement.execute("CREATE TABLE staff (staffID int PRIMARY KEY, name VARCHAR(50) NOT NULL, " +
                    "branchID int REFERENCES branch (branchID));");
            System.out.println("tables have been created!");

            // add some tuples
            for (int i = 0; i < 5; i++) {
                String content = "INSERT INTO branch VALUES (" + i + ", 'no address :(')";
                System.out.println("next query->" + content);
                statement.execute(content);
                content = "INSERT INTO staff VALUES (" + i + ", 'no name', " + i + ")";
                System.out.println("next query->" + content);
                statement.execute(content);
            }
            System.out.println("some tuples have been added.");

            // apply queries
            String query = "SELECT * FROM staff NATURAL JOIN branch";
            System.out.println("next query->" + query);
            statement.execute(query);
            ResultSet rs = statement.getResultSet();
            while (rs.next()) {
                System.out.println("Staff ID " + rs.getInt("staffID") + ":");
                System.out.println("He works in branch " + rs.getInt("branchID")
                        + " and the address ist: " + rs.getString("address"));
            }

            // success !!!!
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
