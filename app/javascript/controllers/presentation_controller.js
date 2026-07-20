import { Controller } from "@hotwired/stimulus"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

export default class extends Controller {
  static targets = ["section", "progress", "blob"]

  connect() {
    this.sectionTargets.forEach((section) => {
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: section,
          start: "top top",
          end: "+=100%",
          pin: true,
          pinSpacing: true,
          scrub: 0.5,
        },
      })

      const key = section.dataset.section
      if (key === "hook") this.buildHook(tl, section)
      else if (key === "gaps") this.buildGaps(tl, section)
      else if (key === "lifecycle") this.buildLifecycle(tl, section)
      else if (key === "architecture") this.buildArchitecture(tl, section)
      else if (key === "demo") this.buildDemo(tl, section)
      else if (key === "future") this.buildFuture(tl, section)
      else this.buildDefault(tl, section)
    })

    this.animateCounters()

    this.progressTarget && gsap.to(this.progressTarget, {
      scaleX: 1,
      ease: "none",
      transformOrigin: "left",
      scrollTrigger: {
        trigger: this.element,
        start: "top top",
        end: "bottom bottom",
        scrub: true,
      },
    })
  }

  
  animateCounters() {
    const counters = this.element.querySelectorAll("[data-count-to]")

    counters.forEach((el) => {
      const target = parseInt(el.dataset.countTo, 10)
      const counter = { value: 0 }

      gsap.to(counter, {
        value: target,
        duration: 1.5,
        ease: "power1.out",
        snap: { value: 1 },
        onUpdate: () => {
          el.textContent = counter.value
        },
        scrollTrigger: {
          trigger: el,
          start: "top 80%",
          toggleActions: "play none none reverse",
        },
      })
    })
  }

  buildDefault(tl, section) {
    const reveals = section.querySelectorAll("[data-reveal]")
    gsap.set(reveals, { opacity: 0, y: 40 })
    tl.to(reveals, { opacity: 1, y: 0, stagger: 0.15, ease: "power2.out" })
  }

  buildHook(tl, section) {
    const eyebrow = section.querySelector("p[data-reveal]:first-of-type")
    const headline = section.querySelector("h1")
    const sub = section.querySelectorAll("p[data-reveal]")
    const stat = sub[sub.length - 1]
    const counters = section.querySelectorAll("[data-count-to]")
    const blob = section.querySelector("[data-presentation-target='blob']")

    gsap.set([eyebrow, headline, ...sub], { opacity: 0, y: 50 })
    gsap.set(headline, { scale: 1.15, y: 30 })

    tl.to(eyebrow, { opacity: 1, y: 0, duration: 0.3 })
      .to(headline, { opacity: 1, y: 0, scale: 1, duration: 0.5 }, "-=0.1")
      .to(sub[0], { opacity: 1, y: 0, duration: 0.4 }, "-=0.2")
      .to(stat, { opacity: 1, y: 0, duration: 0.4 }, "-=0.2")

    counters.forEach((el) => {
      const target = parseInt(el.dataset.countTo, 10)
      const counter = { val: 0 }
      tl.to(counter, {
        val: target,
        duration: 0.6,
        onUpdate: () => { el.textContent = Math.round(counter.val) },
      }, "-=0.3")
    })

    if (blob) {
      gsap.set(blob, { y: 0 })
      tl.to(blob, { y: -120, duration: 1.2, ease: "none" }, 0)
    }
  }

  buildGaps(tl, section) {
    const heading = section.querySelector("h2")
    const rows = section.querySelectorAll("[data-gap-row]")
    const closing = section.querySelector("p[data-reveal]:last-of-type")

    gsap.set(heading, { opacity: 0, y: 30 })
    tl.to(heading, { opacity: 1, y: 0, duration: 0.3 })

    rows.forEach((row) => {
      const old = row.querySelector("[data-gap-old]")
      const arrow = row.querySelector("[data-gap-arrow]")
      const next = row.querySelector("[data-gap-new]")

      gsap.set(old, { opacity: 0, x: -40 })
      gsap.set(arrow, { opacity: 0, rotate: -90, scale: 0.5 })
      gsap.set(next, { opacity: 0, x: 40 })

      tl.to(old, { opacity: 1, x: 0, duration: 0.3 }, "+=0.05")
        .to(arrow, { opacity: 1, rotate: 0, scale: 1, duration: 0.25 }, "-=0.1")
        .to(next, { opacity: 1, x: 0, duration: 0.3 }, "-=0.1")
    })

    if (closing) {
      gsap.set(closing, { opacity: 0, y: 20 })
      tl.to(closing, { opacity: 1, y: 0, duration: 0.3 })
    }
  }

  buildLifecycle(tl, section) {
    const heading = section.querySelector("h2")
    const line = section.querySelector("[data-lifecycle-line]")
    const pills = section.querySelectorAll("[data-lifecycle-pill]")
    const branch = section.querySelector("[data-lifecycle-branch]")
    const reopened = section.querySelector("[data-lifecycle-reopened]")
    const desc = section.querySelector("p[data-reveal]")

    gsap.set(heading, { opacity: 0, y: 30 })
    gsap.set(pills, { opacity: 0, scale: 0.6 })

    tl.to(heading, { opacity: 1, y: 0, duration: 0.3 })
      .to(line, { scaleX: 1, duration: 0.8, ease: "none" }, "+=0.05")

    pills.forEach((pill, i) => {
      tl.to(pill, { opacity: 1, scale: 1, duration: 0.25, ease: "back.out(2)" },
        `<${i === 0 ? 0 : 0.15}`)
    })

    tl.to(branch, { scaleY: 1, duration: 0.3, ease: "power1.out" }, "+=0.1")
      .to(reopened, { opacity: 1, duration: 0.3 }, "-=0.1")

    if (desc) {
      gsap.set(desc, { opacity: 0, y: 20 })
      tl.to(desc, { opacity: 1, y: 0, duration: 0.3 })
    }
  }

  buildArchitecture(tl, section) {
    const heading = section.querySelector("h2")
    const tiles = section.querySelectorAll("[data-tile]")
    const list = section.querySelectorAll("li[data-reveal]")
    const footnote = section.querySelector("p[data-reveal]:last-of-type")

    gsap.set(heading, { opacity: 0, y: 30 })
    tl.to(heading, { opacity: 1, y: 0, duration: 0.3 })

    tiles.forEach((tile, i) => {
      const fromX = i % 2 === 0 ? -60 : 60
      const fromY = i % 4 < 2 ? -40 : 40
      gsap.set(tile, { opacity: 0, x: fromX, y: fromY, rotate: fromX > 0 ? 8 : -8 })
      tl.to(tile, { opacity: 1, x: 0, y: 0, rotate: 0, duration: 0.35, ease: "power2.out" },
        `<${i === 0 ? 0 : 0.06}`)
    })

    gsap.set(list, { opacity: 0, x: -20 })
    tl.to(list, { opacity: 1, x: 0, stagger: 0.1, duration: 0.3 }, "+=0.1")

    if (footnote) {
      gsap.set(footnote, { opacity: 0 })
      tl.to(footnote, { opacity: 1, duration: 0.3 })
    }
  }

  buildDemo(tl, section) {
    const heading = section.querySelector("h2")
    const items = section.querySelectorAll("[data-demo-item]")
    const closing = section.querySelector("p[data-reveal]")

    gsap.set(heading, { opacity: 0, y: 30 })
    tl.to(heading, { opacity: 1, y: 0, duration: 0.3 })

    items.forEach((item, i) => {
      const fromX = i % 2 === 0 ? -50 : 50
      gsap.set(item, { opacity: 0, x: fromX, rotate: fromX > 0 ? 3 : -3 })
      tl.to(item, { opacity: 1, x: 0, rotate: 0, duration: 0.3, ease: "power2.out" },
        `<${i === 0 ? 0 : 0.12}`)
    })

    if (closing) {
      gsap.set(closing, { opacity: 0 })
      tl.to(closing, { opacity: 1, duration: 0.3 })
    }
  }

  buildFuture(tl, section) {
    const heading = section.querySelector("h2")
    const paras = section.querySelectorAll("p[data-reveal]")
    const cta = section.querySelector("[data-future-cta]")
    const blob = section.querySelector("[data-presentation-target='blob']")

    gsap.set(heading, { opacity: 0, y: 30 })
    gsap.set(paras, { opacity: 0, y: 30 })
    gsap.set(cta, { opacity: 0, scale: 0.75 })

    tl.to(heading, { opacity: 1, y: 0, duration: 0.3 })
      .to(paras[0], { opacity: 1, y: 0, duration: 0.35 }, "-=0.1")
      .to(paras[1], { opacity: 1, y: 0, duration: 0.35 }, "-=0.15")
      .to(cta, { opacity: 1, scale: 1, duration: 0.4, ease: "elastic.out(1, 0.5)" }, "+=0.1")

    if (blob) tl.to(blob, { y: 100, duration: 1.2, ease: "none" }, 0)
  }

  disconnect() {
    ScrollTrigger.getAll().forEach((trigger) => trigger.kill())
  }
}