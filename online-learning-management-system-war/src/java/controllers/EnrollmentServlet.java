/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import entities.AppUser;
import entities.Enrollment;
import jakarta.ejb.EJB;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import session.EnrollmentSBLocal;

/**
 *
 * @author Admin
 */
public class EnrollmentServlet extends HttpServlet {

    @EJB
    private EnrollmentSBLocal enrollmentSB;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer currentUserId = requireLogin(req, resp);
        if (currentUserId == null) {
            return;
        }

        String action = get(req, "action", "list");
        List<Enrollment> enrollments = enrollmentSB.getEnrollmentsByStudent(currentUserId);
        req.setAttribute("enrollments", enrollments);

        switch (action) {
            case "dashboard" ->
                req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
            case "list" ->
                req.getRequestDispatcher("/enrollment/list.jsp").forward(req, resp);
            default ->
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer currentUserId = requireLogin(req, resp);
        if (currentUserId == null) {
            return;
        }

        String action = get(req, "action", "");
        try {
            switch (action) {
                case "enroll" -> {
                    Integer courseId = Integer.valueOf(req.getParameter("courseId"));
                    enrollmentSB.enrollStudent(courseId, currentUserId);
                    resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=list");
                }
                case "unenroll" -> {
                    Integer courseId = Integer.valueOf(req.getParameter("courseId"));
                    enrollmentSB.unenroll(courseId, currentUserId);
                    resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=list");
                }
                case "updateProgress" -> {
                    Integer courseId = Integer.valueOf(req.getParameter("courseId"));
                    BigDecimal progress = new BigDecimal(req.getParameter("progress"));
                    enrollmentSB.updateProgress(courseId, currentUserId, progress);
                    resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=dashboard");
                }
                default ->
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/enrollment/list.jsp").forward(req, resp);
        }
    }
    
        // --------- helpers ----------
    private static String get(HttpServletRequest req, String name, String defVal) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? defVal : v.trim();
    }

    /** lay current user tu session; Authentication da set "user" la AppUser. */
    private Integer requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        var session = req.getSession(false);
        if (session != null) {
            Object u = session.getAttribute("user");
            if (u instanceof AppUser) {
                return ((AppUser) u).getUserId();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
        return null;
    }

}
