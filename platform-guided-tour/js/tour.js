// Tour Navigation Script - Slide-based
class PlatformTour {
    constructor() {
        this.currentSlide = 0;
        this.totalSlides = 7; // 0 = Welcome, 1-6 = Steps
        this.init();
    }

    init() {
        this.updateSlide(0);
        this.setupKeyboardNavigation();
    }

    setupKeyboardNavigation() {
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') {
                this.prevSlide();
            } else if (e.key === 'ArrowRight') {
                this.nextSlide();
            }
        });
    }

    goToSlide(slideIndex) {
        if (slideIndex >= 0 && slideIndex < this.totalSlides) {
            this.currentSlide = slideIndex;
            this.updateSlide(slideIndex);
        }
    }

    nextSlide() {
        if (this.currentSlide < this.totalSlides - 1) {
            this.currentSlide++;
            this.updateSlide(this.currentSlide);
        }
    }

    prevSlide() {
        if (this.currentSlide > 0) {
            this.currentSlide--;
            this.updateSlide(this.currentSlide);
        }
    }

    finish() {
        // Could redirect or show completion message
        alert('Tour complete! Thank you for exploring the Salesforce Platform.');
    }

    updateSlide(slideIndex) {
        // Update slide visibility
        const slides = document.querySelectorAll('.tour-slide');
        slides.forEach((slide, index) => {
            if (index === slideIndex) {
                slide.classList.add('active');
            } else {
                slide.classList.remove('active');
            }
        });

        // Update slide indicators
        const indicators = document.querySelectorAll('.slide-indicator');
        indicators.forEach((indicator) => {
            if (slideIndex === 0) {
                // Welcome slide - hide indicator or show "Welcome"
                indicator.textContent = 'Welcome';
            } else {
                indicator.textContent = `${slideIndex} / 6`;
            }
        });

        // Update navigation buttons
        const prevButtons = document.querySelectorAll('.btn-prev');
        const nextButtons = document.querySelectorAll('.btn-next');

        prevButtons.forEach(btn => {
            btn.disabled = slideIndex === 0;
        });

        nextButtons.forEach(btn => {
            if (slideIndex === this.totalSlides - 1) {
                btn.textContent = 'Finish';
            } else {
                btn.textContent = 'Next';
            }
        });

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

// Initialize tour
const tour = new PlatformTour();

// Make tour globally available for onclick handlers
window.tour = tour;