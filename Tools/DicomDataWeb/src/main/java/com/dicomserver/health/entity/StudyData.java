package com.dicomserver.health.entity;

import com.google.gson.annotations.SerializedName;

import java.text.SimpleDateFormat;
import java.util.Date;

//序列化参考 https://github.com/whiskeyfei/Gson-Review
//SerializedName注解提供了两个属性，上面用到了其中一个，另外还有一个属性alternate，接收一个String数组。
//@SerializedName(value = "emailAddress", alternate = {"email", "email_address"})
//public String emailAddress;
//        当上面的三个属性 email_address、email、emailAddress 中出现任意一个时均可以得到正确的结果。
//        当多种情况同时出时，以最后一个出现的值为准。
public class StudyData {
    //patient table
    private String PatientIdentity;
    private String PatientName;//PatientNameEnglish
    private String PatientID;
    private String PatientSex;
    private String PatientBirthday;
    private String PatientTelNumber;
    private String PatientAddr, PatientCarID, PatientType, PatientEmail;// to do creat history table

    //order table ->patient :PatientIdentity
    private String StudyOrderIdentity;
    private String StudyID;
    private String StudyUID;
    //@SerializedName(value = "ScheduledDate", alternate = {"ScheduledDate","Scheduled"})
    @SerializedName("ScheduledDate")
    private String ScheduledDateTime;
    private String OrderDateTime;
    private String StudyDescription;
    private String StudyModality;
    private String AETitle;
    private String StudyType, StudyCode, StudyState, StudyCost;

    //study image table ->patient :PatientIdentity
    private String StudyDateTime, sStudyID, StudyDepart, sStudyModality, sStudyUID, CostType;
    static String UID = "1.2.826.0.1.3680043.9.7604.";

    public String creatPatientIdentity() {
//        Random rand =new Random(System.currentTimeMillis());
//        return Long.toUnsignedString(System.currentTimeMillis() + rand.nextLong()) ;
        return Long.toUnsignedString(System.currentTimeMillis());
    }

    public String creatPatientID() {
//        Random rand =new Random(System.currentTimeMillis());
//        return Long.toUnsignedString(System.currentTimeMillis() + rand.nextLong()) ;
        return Long.toUnsignedString(System.currentTimeMillis());
    }

    public String creatStudyIdentity() {
//        Random rand =new Random(System.currentTimeMillis());
//        return Long.toUnsignedString(System.currentTimeMillis() + rand.nextLong()) ;
        return Long.toUnsignedString(System.currentTimeMillis());
    }

    public String creatStudyID() {
        String id = "";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        //得到long类型当前时间
        long l = System.currentTimeMillis();
        //new日期对象
        Date date = new Date(l);
        id = dateFormat.format(date);
        return id;
    }

    public String creatStudyUID() {
        String uid = "";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss.");
        //得到long类型当前时间
        long l = System.currentTimeMillis();
        //new日期对象
        Date date = new Date(l);
        uid = dateFormat.format(date) + Long.toUnsignedString(System.currentTimeMillis()).substring(0, 6);
        return UID + uid;
    }

    public String getStudyOrderIdentity() {
        return StudyOrderIdentity;
    }

    public void setStudyOrderIdentity(String StudyOrderIdentity) {
        this.StudyOrderIdentity = StudyOrderIdentity;
    }

    public String getScheduledDateTime() {
        return ScheduledDateTime;
    }

    public void setScheduledDateTime(String ScheduledDateTime) {
        this.ScheduledDateTime = ScheduledDateTime;
    }

    public String getOrderDateTime() {
        return OrderDateTime;
    }

    public void setOrderDateTime(String StudyDateTime) {
        this.OrderDateTime = OrderDateTime;
    }

    public String getStudyUID() {
        return StudyUID;
    }

    public void setStudyUID(String StudyUID) {
        this.StudyUID = StudyUID;
    }

    //
    public String getStudyDescription() {
        return StudyDescription;
    }

    public void setStudyDescription(String StudyDescription) {
        this.StudyDescription = StudyDescription;
    }

    public String getStudyModality() {
        return StudyModality;
    }

    public void setStudyModality(String StudyModality) {
        this.StudyModality = StudyModality;
    }

    public String getStudyDepart() {
        return StudyDepart;
    }

    public void setStudyDepart(String StudyDepart) {
        this.StudyDepart = StudyDepart;
    }

    public String getAETitle() {
        return AETitle;
    }

    public void setAETitle(String AETitle) {
        this.AETitle = AETitle;
    }

    public String getStudyType() {
        return StudyType;
    }

    public void setStudyType(String StudyType) {
        this.StudyType = StudyType;
    }

    public String getStudyCode() {
        return StudyCode;
    }

    public void setStudyCode(String StudyCode) {
        this.StudyCode = StudyCode;
    }

    public String getStudyState() {
        return StudyState;
    }

    public void setStudyState(String StudyState) {
        this.StudyState = StudyState;
    }

    public String getStudyCost() {
        return StudyCost;
    }

    public void setStudyCost(String StudyCost) {
        this.StudyCost = StudyCost;
    } //

    public String getCostType() {
        return CostType;
    }

    public void setCostType(String CostTpye) {
        this.CostType = CostTpye;
    }

    public String getStudyID() {
        return StudyID;
    }

    public void setStudyID(String StudyID) {
        this.StudyID = StudyID;
    }

    public String getPatientIdentity() {
        return PatientIdentity;
    }

    public void setPatientIdentity(String PatientIdentity) {
        this.PatientIdentity = PatientIdentity;
    }

    public String getPatientName() {
        return PatientName;
    }

    public void setPatientName(String name) {
        this.PatientName = name;
    }

    public String getPatientID() {
        return PatientID;
    }

    public void setPatientID(String PatientID) {
        this.PatientID = PatientID;
    }

    public String getPatientSex() {
        return PatientSex;
    }

    public void setPatientSex(String sex) {
        this.PatientSex = sex;
    }

    public String getPatientBirthday() {
        return PatientBirthday;
    }

    public void setPatientBirthday(String birthday) {
        this.PatientBirthday = birthday;
    }

    public String getPatientTelNumber() {
        return PatientTelNumber;
    }

    public void setPatientTelNumber(String patientTelNumber) {
        this.PatientTelNumber = patientTelNumber;
    }

    public String getPatientAddr() {
        return PatientAddr;
    }

    public void setPatientAddr(String PatientAddr) {
        this.PatientAddr = PatientAddr;
    }

    public String getPatientEmail() {
        return PatientEmail;
    }

    public void setPatientEmail(String PatientEmail) {
        this.PatientEmail = PatientEmail;
    }

    public String getPatientCarID() {
        return PatientCarID;
    }

    public void setPatientCarID(String PatientCarID) {
        this.PatientCarID = PatientCarID;
    }

    public String getPatientType() {
        return PatientType;
    }

    public void setPatientType(String PatientType) {
        this.PatientType = PatientType;
    }

    //----------study table
    public String getStudyDateTime() {
        return StudyDateTime;
    }

    public void setStudyDateTime(String StudyDateTime) {
        this.StudyDateTime = StudyDateTime;
    }

    public String getsStudyID() {
        return sStudyID;
    }

    public void setsStudyID(String sStudyID) {
        this.sStudyID = sStudyID;
    }

    public String getsStudyModality() {
        return sStudyModality;
    }

    public void setsStudyModality(String sStudyModality) {
        this.sStudyModality = sStudyModality;
    }

    public String getsStudyUID() {
        return sStudyUID;
    }

    public void setsStudyUID(String sStudyUID) {
        this.sStudyUID = sStudyUID;
    }
}
