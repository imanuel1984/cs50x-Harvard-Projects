document.addEventListener("DOMContentLoaded", () => {
  // footer year
  const yearEl = document.querySelector("#year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // greeting
  const greet = document.querySelector("#greeting");
  if (greet) {
    const h = new Date().getHours();
    const msg = h < 12 ? "Good morning!" : h < 18 ? "Good afternoon!" : "Good evening!";
    greet.textContent = msg + " Welcome to my homepage.";
  }

  // theme toggle
  const themeBtn = document.querySelector("#themeBtn");
  if (themeBtn) {
    themeBtn.addEventListener("click", () => {
      document.body.classList.toggle("dark");
    });
  }

  // quote button (projects page)
  const quoteBtn = document.querySelector("#quoteBtn");
  const quoteOut = document.querySelector("#quoteOut");
  const quotes = [
    "Ship small, learn fast.",
    "Consistency beats intensity.",
    "Debugging is a superpower.",
    "One step at a time."
  ];
  if (quoteBtn && quoteOut) {
    quoteBtn.addEventListener("click", () => {
      const i = Math.floor(Math.random() * quotes.length);
      quoteOut.textContent = quotes[i];
    });
  }

  // contact form feedback
  const form = document.querySelector("#contactForm");
  const status = document.querySelector("#formStatus");
  if (form && status) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      status.innerHTML = '<div class="alert alert-success mb-0" role="alert">Message sent! (demo)</div>';
      form.reset();
    });
  }
});
