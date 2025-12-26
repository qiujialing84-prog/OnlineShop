package com.onlineshop.model;

import java.sql.Timestamp;

public class Customer {
    private int id;   //用户id,唯一
    private String username;
    private String password;
    private String email;
    private String phone;
    private String address;
    private Timestamp registrationDate;  //时间戳，记录当前时间

    //构造方法
    public Customer(){};

    public Customer(String name,String password,String email) {
        this.username = name;
        this.password = password;
        this.email = email;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) {
        this.registrationDate = registrationDate;
    }
}
