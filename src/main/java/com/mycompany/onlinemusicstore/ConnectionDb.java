/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.onlinemusicstore;
import java.sql.*;
/**
 *
 * @author asoual
 */

public class ConnectionDb {
    public static Connection getConnection(){
        String url = "jdbc:postgresql://localhost/musicstore";
        String uid = "soualhiaa";
        String pw = "soualhiaa";
        Connection conn=null;
    try {conn =DriverManager.getConnection(url,uid,pw);
    System.out.println("Connected to PostgreSQL server");
    return conn;
}catch (SQLException e){
    System.out.println("Error in connecting to postgresql server");
    
}
        return conn;
}
}