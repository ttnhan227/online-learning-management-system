/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author ttnha
 */
@Entity
@Table(name = "app_user")
@NamedQueries({
    @NamedQuery(name = "AppUser.findAll", query = "SELECT a FROM AppUser a"),
    @NamedQuery(name = "AppUser.findByUserId", query = "SELECT a FROM AppUser a WHERE a.userId = :userId"),
    @NamedQuery(name = "AppUser.findByFullName", query = "SELECT a FROM AppUser a WHERE a.fullName = :fullName"),
    @NamedQuery(name = "AppUser.findByEmail", query = "SELECT a FROM AppUser a WHERE a.email = :email"),
    @NamedQuery(name = "AppUser.findByPasswordHash", query = "SELECT a FROM AppUser a WHERE a.passwordHash = :passwordHash"),
    @NamedQuery(name = "AppUser.findByCreatedAt", query = "SELECT a FROM AppUser a WHERE a.createdAt = :createdAt")})
public class AppUser implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "user_id")
    private Integer userId;
    @Basic(optional = false)
    @Column(name = "full_name")
    private String fullName;
    @Basic(optional = false)
    @Column(name = "email")
    private String email;
    @Basic(optional = false)
    @Column(name = "password_hash")
    private String passwordHash;
    @Column(name = "photo_url")
    private String photoUrl;
    
    @Column(name = "is_approved")
    private Boolean isApproved = false;
    
    @Column(name = "verification_document")
    private String verificationDocument;
    
    @Column(name = "department", length = 100)
    private String department;
    
    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;
    
    @Basic(optional = false)
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @OneToMany(mappedBy = "userId")
    private List<UserRole> userRoleList;
    // User roles are managed through the UserRole entity
    // Temporarily commented out to fix circular reference issue
    // @OneToMany(mappedBy = "instructorId")
    // private List<Course> courseList;
    // @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    // private List<Enrollment> enrollmentList;

    public AppUser() {
    }

    public AppUser(Integer userId) {
        this.userId = userId;
    }

    public AppUser(Integer userId, String fullName, String email, String passwordHash, Date createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.createdAt = createdAt;
        this.isApproved = false;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }
    
    public Boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }

    public String getVerificationDocument() {
        return verificationDocument;
    }

    public void setVerificationDocument(String verificationDocument) {
        this.verificationDocument = verificationDocument;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public List<UserRole> getUserRoleList() {
        return userRoleList;
    }
    
    public void setUserRoleList(List<UserRole> userRoleList) {
        this.userRoleList = userRoleList;
    }

    // User roles are managed through the UserRole entity

    // Temporarily commented out to fix circular reference issue
    // public List<Course> getCourseList() {
    //     return courseList;
    // }
    // 
    // public void setCourseList(List<Course> courseList) {
    //     this.courseList = courseList;
    // }
    // 
    // public List<Enrollment> getEnrollmentList() {
    //     return enrollmentList;
    // }
    // 
    // public void setEnrollmentList(List<Enrollment> enrollmentList) {
    //     this.enrollmentList = enrollmentList;
    // }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (userId != null ? userId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AppUser)) {
            return false;
        }
        AppUser other = (AppUser) object;
        if ((this.userId == null && other.userId != null) || (this.userId != null && !this.userId.equals(other.userId))) {
            return false;
        }
        return true;
    }

    
    
}
