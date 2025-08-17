<style>
    footer {
        background: #f8f9fc;
        padding: 2rem 0;
        margin-top: 3rem;
        border-top: 1px solid #e3e6f0;
        color: #5a5c69;
        font-size: 0.9rem;
    }
    
    footer .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 1rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }
    
    footer p {
        margin: 0;
    }
    
    .footer-links {
        display: flex;
        gap: 1.5rem;
    }
    
    .footer-links a {
        color: #4e73df;
        text-decoration: none;
        transition: color 0.2s;
    }
    
    .footer-links a:hover {
        color: #2e59d9;
        text-decoration: underline;
    }
    
    .social-links {
        display: flex;
        gap: 1rem;
    }
    
    .social-links a {
        color: #6c757d;
        font-size: 1.2rem;
        transition: color 0.2s;
    }
    
    .social-links a:hover {
        color: #4e73df;
    }
    
    @media (max-width: 768px) {
        footer .container {
            flex-direction: column;
            text-align: center;
            gap: 1.5rem;
        }
        
        .footer-links {
            flex-direction: column;
            gap: 0.75rem;
        }
    }
</style>

<footer>
    <div class="container">
        <p>&copy; 2025 EduLMS. All rights reserved.</p>
        
        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a>
            <a href="${pageContext.request.contextPath}/terms">Terms of Service</a>
            <a href="${pageContext.request.contextPath}/contact">Contact Us</a>
        </div>
        
        <div class="social-links">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin"></i></a>
            <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
        </div>
    </div>
</footer>
