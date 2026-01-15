// Algoinsu Ghost Theme - Main JavaScript

(function() {
    'use strict';

    // Wait for DOM to be ready
    document.addEventListener('DOMContentLoaded', function() {
        initSmoothScrolling();
        initHeaderScroll();
        initPostAnimations();
        initNewsletterForm();
    });

    // Smooth scrolling for anchor links
    function initSmoothScrolling() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href === '#') return;
                
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    // Header scroll effect
    function initHeaderScroll() {
        const header = document.querySelector('.site-header');
        if (!header) return;

        let lastScroll = 0;
        
        window.addEventListener('scroll', () => {
            const currentScroll = window.pageYOffset;
            
            if (currentScroll > 100) {
                header.style.boxShadow = 'var(--shadow-md)';
                header.style.background = 'rgba(255, 255, 255, 0.98)';
            } else {
                header.style.boxShadow = 'var(--shadow-sm)';
                header.style.background = 'var(--color-white)';
            }
            
            lastScroll = currentScroll;
        });
    }

    // Post card animations
    function initPostAnimations() {
        const postCards = document.querySelectorAll('.post-card');
        if (!postCards.length) return;

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        });

        postCards.forEach((card, index) => {
            // Set initial state
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = `opacity 0.4s ease-out ${index * 0.1}s, transform 0.4s ease-out ${index * 0.1}s`;
            observer.observe(card);
        });
    }

    // Newsletter form handling
    function initNewsletterForm() {
        const forms = document.querySelectorAll('form[action*="subscribe"]');
        
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const emailInput = this.querySelector('input[type="email"]');
                if (emailInput && !emailInput.value) {
                    e.preventDefault();
                    emailInput.focus();
                    emailInput.style.borderColor = 'var(--color-gold)';
                    return;
                }
                
                // Show loading state
                const submitBtn = this.querySelector('input[type="submit"]');
                if (submitBtn) {
                    const originalText = submitBtn.value;
                    submitBtn.value = 'Subscribing...';
                    submitBtn.disabled = true;
                    
                    // Reset after 3 seconds (in case of error)
                    setTimeout(() => {
                        submitBtn.value = originalText;
                        submitBtn.disabled = false;
                    }, 3000);
                }
            });
        });
    }

    // Add hover effects for interactive elements
    function initInteractiveEffects() {
        const buttons = document.querySelectorAll('.btn-signup, .btn-signin, .btn-account');
        
        buttons.forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    }

    // Track page views (basic analytics)
    function trackPageView() {
        if (typeof gtag !== 'undefined') {
            gtag('event', 'page_view', {
                page_title: document.title,
                page_location: window.location.href
            });
        }
    }

    // Expose to global scope for Ghost compatibility
    window.AlgoinsuTheme = {
        init: function() {
            initSmoothScrolling();
            initHeaderScroll();
            initPostAnimations();
            initNewsletterForm();
            initInteractiveEffects();
            trackPageView();
        }
    };

})();
