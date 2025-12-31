(() => {
  function initNavTabs() {
    const list = document.querySelector("[data-nav-tabs]");
    if (!list) return;

    list.addEventListener("click", (e) => {
      const btn = e.target && e.target.closest ? e.target.closest("[data-nav-tab]") : null;
      if (!btn) return;
      const li = btn.closest(".nav__item");
      if (!li) return;

      list.querySelectorAll(".nav__item").forEach((el) => el.classList.remove("is-active"));
      li.classList.add("is-active");
    });
  }

  function initGenreTabs() {
    const root = document.querySelector("[data-genre-tabs]");
    if (!root) return;

    root.addEventListener("click", (e) => {
      const btn = e.target && e.target.closest ? e.target.closest(".genre-tabs__btn") : null;
      if (!btn) return;
      root.querySelectorAll(".genre-tabs__btn").forEach((el) => el.classList.remove("is-active"));
      btn.classList.add("is-active");
    });
  }

  function initHeroSlider() {
    const root = document.querySelector("[data-hero]");
    if (!root) return;

    const track = root.querySelector("[data-hero-track]");
    const slides = Array.from(root.querySelectorAll("[data-hero-slide]"));
    const dots = Array.from(root.querySelectorAll("[data-hero-dot]"));
    const prevBtn = root.querySelector("[data-hero-prev]");
    const nextBtn = root.querySelector("[data-hero-next]");

    if (!track || slides.length === 0) return;

    let index = 0;
    let timer = null;
    const intervalMs = 4000;

    function setActive(i) {
      const max = slides.length;
      index = ((i % max) + max) % max;
      track.style.transform = `translateX(-${index * 100}%)`;

      dots.forEach((d, di) => d.classList.toggle("is-active", di === index));
      slides.forEach((s, si) => s.setAttribute("aria-hidden", si === index ? "false" : "true"));
    }

    function start() {
      stop();
      timer = window.setInterval(() => setActive(index + 1), intervalMs);
    }

    function stop() {
      if (timer !== null) {
        window.clearInterval(timer);
        timer = null;
      }
    }

    if (prevBtn) prevBtn.addEventListener("click", () => setActive(index - 1));
    if (nextBtn) nextBtn.addEventListener("click", () => setActive(index + 1));
    dots.forEach((dot, di) => dot.addEventListener("click", () => setActive(di)));

    root.addEventListener("mouseenter", stop);
    root.addEventListener("mouseleave", start);

    setActive(0);
    start();
  }

  function initCarousels() {
    const carousels = Array.from(document.querySelectorAll("[data-carousel]"));
    if (carousels.length === 0) return;

    carousels.forEach((root) => {
      const viewport = root.querySelector("[data-carousel-viewport]");
      const track = root.querySelector("[data-carousel-track]");
      const prevBtn = root.querySelector("[data-carousel-prev]");
      const nextBtn = root.querySelector("[data-carousel-next]");
      if (!viewport) return;

      const getStep = () => {
        // "한 카드씩" 확실하게 이동 (배너/오픈예정 모두 공통)
        const item = root.querySelector(".carousel__item");
        if (!item) return Math.max(240, Math.floor(viewport.clientWidth * 0.9));

        let gap = 18;
        if (track) {
          const g = window.getComputedStyle(track).gap;
          const parsed = parseFloat(g);
          if (!Number.isNaN(parsed)) gap = parsed;
        }

        return Math.max(200, Math.round(item.getBoundingClientRect().width + gap));
      };

      const canScroll = () => viewport.scrollWidth > viewport.clientWidth + 2;

      if (prevBtn) {
        prevBtn.addEventListener("click", () => {
          if (!canScroll()) return;
          viewport.scrollBy({ left: -getStep(), behavior: "smooth" });
        });
      }
      if (nextBtn) {
        nextBtn.addEventListener("click", () => {
          if (!canScroll()) return;
          viewport.scrollBy({ left: getStep(), behavior: "smooth" });
        });
      }
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    initNavTabs();
    initGenreTabs();
    initHeroSlider();
    initCarousels();
  });
})();

