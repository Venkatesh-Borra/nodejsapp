<template>
  <div class="site-shell">
    <header class="topbar">
      <div class="container topbar-inner">
        <div class="brand-mark" @click="navigate('home')">
          <span class="brand-symbol">ॐ</span>
          <div>
            <strong>Vontimitta</strong>
            <small>Heritage • History • Devotion</small>
          </div>
        </div>

        <button class="menu-button" @click="mobileOpen = !mobileOpen" aria-label="Toggle menu">
          ☰
        </button>

        <nav :class="{ open: mobileOpen }">
          <button v-for="item in navItems" :key="item.id" @click="navigate(item.id)">
            {{ item.label }}
          </button>
        </nav>
      </div>
    </header>

    <main>
      <section v-if="page === 'home'" class="hero">
        <div class="hero-overlay"></div>
        <div class="container hero-content">
          <p class="eyebrow">ఏకశిలా నగరం • EKASHILA NAGARAM</p>
          <h1>Vontimitta</h1>
          <h2>A living story carved in stone.</h2>
          <p class="hero-copy">
            Explore the heritage of Sri Kodandarama Swamy Temple — its legends,
            architecture, festivals and the living traditions of Vontimitta.
          </p>
          <div class="hero-actions">
            <button class="primary-btn" @click="navigate('history')">Explore History</button>
            <button class="ghost-btn" @click="navigate('gallery')">View Gallery</button>
          </div>
        </div>
      </section>

      <section v-if="page === 'home'" class="intro section">
        <div class="container two-col">
          <div>
            <p class="eyebrow dark">THE SACRED TOWN</p>
            <h2 class="section-title">Where stone, story and devotion meet.</h2>
          </div>
          <p class="lead">
            ఆంధ్రప్రదేశ్‌లోని వైఎస్సార్ కడప జిల్లాలో ఉన్న ఒంటిమిట్ట ఒక విశిష్టమైన చారిత్రక, ఆధ్యాత్మిక పుణ్యక్షేత్రం. ఇక్కడి శ్రీ కోదండరామ స్వామి ఆలయంలో సీత, రామ, లక్ష్మణుల విగ్రహాలు ఒకే రాతిపై (ఏకశిల) చెక్కబడి ఉండటం ప్రధాన విశేషం. యుద్ధకాండకు పూర్వపు ఘట్టాన్ని ప్రతిబింబించేలా ఈ మూలవిరాట్టు చెక్కినందువల్ల ఇక్కడ గర్భగుడిలో హనుమంతుడి విగ్రహం కనిపించదు. ఈ క్షేత్రాన్ని భక్తులు "ఆంధ్ర భద్రాద్రి" మరియు "ఏకశిలా నగరం" అని పిలుస్తారు. విజయనగర, చోళ రాజుల కాలం నాటి అద్భుత శిల్పకళకు నిలయమైన ఈ ఆలయంలోనే భక్తకవి బమ్మెర పోతన తన శ్రీమదాంధ్ర భాగవతాన్ని రచించి రామునికి అంకితం చేశారని ప్రతీతి. ప్రతి సంవత్సరం శ్రీరామనవమి బ్రహ్మోత్సవాలలో భాగంగా జరిగే సీతారాముల కళ్యాణోత్సవాన్ని ఆంధ్రప్రదేశ్ ప్రభుత్వం అధికారికంగా నిర్వహిస్తుంది. సాధారణంగా పగటిపూట కాకుండా, రాత్రివేళ నిండు పున్నమి వెన్నెల్లో స్వామివారి కళ్యాణం జరగడం ఇక్కడి అరుదైన సాంప్రదాయం. ప్రస్తుతం తిరుమల తిరుపతి దేవస్థానం (TTD) ఆధ్వర్యంలో ఈ ఆలయం అభివృద్ధి చెందుతూ విశేష సంఖ్యలో భక్తులను ఆకర్షిస్తోంది.

            +++++++++++++ VENKATESH +++++++++++++
          </p>
        </div>
      </section>

      <section v-if="page === 'home'" class="feature-strip">
        <div class="container feature-grid">
          <article v-for="item in highlights" :key="item.title" class="feature-card">
            <span>{{ item.icon }}</span>
            <h3>{{ item.title }}</h3>
            <p>{{ item.text }}</p>
          </article>
        </div>
      </section>

      <section v-if="page === 'home'" class="section">
        <div class="container">
          <div class="section-heading">
            <div>
              <p class="eyebrow dark">A GLIMPSE</p>
              <h2 class="section-title">Recent & memorable views</h2>
            </div>
            <button class="text-btn" @click="navigate('gallery')">See all →</button>
          </div>
          <div class="gallery-grid compact">
            <figure v-for="photo in featuredPhotos" :key="photo.title" class="photo-card">
              <img :src="photo.image" :alt="photo.title" loading="lazy" />
              <figcaption>
                <span>{{ photo.year }}</span>
                <strong>{{ photo.title }}</strong>
              </figcaption>
            </figure>
          </div>
        </div>
      </section>

      <section v-if="page === 'history'" class="page-banner">
        <div class="container">
          <p class="eyebrow">THE STORY OF VONTIMITTA</p>
          <h1>History carved in stone</h1>
          <p>Legends, inscriptions and architectural memory across centuries.</p>
        </div>
      </section>

      <section v-if="page === 'history'" class="section">
        <div class="container history-layout">
          <div class="history-main">
            <div v-for="(item, index) in timeline" :key="item.title" class="timeline-item">
              <div class="timeline-dot">{{ String(index + 1).padStart(2, '0') }}</div>
              <div>
                <p class="eyebrow dark">{{ item.era }}</p>
                <h2>{{ item.title }}</h2>
                <p>{{ item.text }}</p>
              </div>
            </div>
          </div>

          <aside class="heritage-card">
            <div class="heritage-card-inner">
              <span class="card-symbol">✦</span>
              <h3>Architectural identity</h3>
              <p>
                The protected monument is noted for its Vijayanagara-style
                character, ornate gopurams, sculpted mandapas and detailed
                stone carvings.
              </p>
              <div class="fact"><strong>3</strong><span>major gopurams</span></div>
              <div class="fact"><strong>32</strong><span>pillars in the celebrated mandapa</span></div>
              <div class="fact"><strong>1</strong><span>single stone for Rama, Sita & Lakshmana</span></div>
            </div>
          </aside>
        </div>
      </section>

      <section v-if="page === 'festival(Tirunala)'" class="page-banner festival-banner">
        <div class="container">
          <p class="eyebrow">TRADITION IN MOTION</p>
          <h1>Festival of Sri Rama</h1>
          <p>Music, flowers, processions and devotion fill Vontimitta during Brahmotsavam.</p>
        </div>
      </section>

      <section v-if="page === 'festival'" class="section">
        <div class="container">
          <div class="festival-intro">
            <p class="drop-cap">
              Vontimitta's festival season transforms the historic temple into
              a living cultural stage. Rituals happen within the temple, while
              processions carry the celebration into the streets.
            </p>
          </div>
          <div class="festival-grid">
            <article v-for="festival in festivals" :key="festival.name" class="festival-card">
              <span class="festival-badge">{{ festival.badge }}</span>
              <h2>{{ festival.name }}</h2>
              <div class="ornament">❈</div>
              <p>{{ festival.text }}</p>
            </article>
          </div>
        </div>
      </section>

      <section v-if="page === 'gallery'" class="page-banner gallery-banner">
        <div class="container">
          <p class="eyebrow">VISUAL MEMORIES</p>
          <h1>Vontimitta in photographs</h1>
          <p>A small collection of recent and historic views.</p>
        </div>
      </section>

      <section v-if="page === 'gallery'" class="section">
        <div class="container">
          <div class="filter-row">
            <button v-for="filter in filters" :key="filter" :class="{ active: activeFilter === filter }" @click="activeFilter = filter">
              {{ filter }}
            </button>
          </div>

          <div class="gallery-grid">
            <figure v-for="photo in filteredPhotos" :key="photo.title" class="photo-card large">
              <img :src="photo.image" :alt="photo.title" loading="lazy" />
              <figcaption>
                <span>{{ photo.category }} • {{ photo.year }}</span>
                <strong>{{ photo.title }}</strong>
                <small>Image: {{ photo.source }}</small>
              </figcaption>
            </figure>
          </div>

          <p class="gallery-note">
            Images are loaded from their respective published sources. Replace
            these URLs with your own licensed/local photographs before public deployment.
          </p>
        </div>
      </section>

      <section v-if="page === 'about'" class="page-banner about-banner">
        <div class="container">
          <p class="eyebrow">ABOUT THIS PROJECT</p>
          <h1>Preserving a place through a digital story</h1>
          <p>A simple static Vue.js heritage blog designed around a traditional visual language.</p>
        </div>
      </section>

      <section v-if="page === 'about'" class="section">
        <div class="container about-grid">
          <article class="paper-card">
            <p class="eyebrow dark">WHY VONTIMITTA?</p>
            <h2>A digital keepsake for a historic town.</h2>
            <p>
              This site is intentionally simple: no database, no login and no
              backend. It is a static Vue application that can be deployed on
              any static hosting platform or served from your own web server.
            </p>
            <p>
              The design uses earthy reds, temple-gold accents, paper textures,
              ornamental borders and serif typography to evoke a traditional
              South Indian heritage publication.
            </p>
          </article>

          <article class="paper-card">
            <p class="eyebrow dark">REFERENCE SOURCES</p>
            <h2>Start with authoritative material.</h2>
            <ul class="source-list">
              <li v-for="source in sources" :key="source.name">
                <a :href="source.url" target="_blank" rel="noreferrer">{{ source.name }} ↗</a>
              </li>
            </ul>
            <p class="small-note">
              Verify dates, rituals and historical claims against official or
              primary sources when expanding the content.
            </p>
          </article>
        </div>
      </section>
    </main>

    <footer>
      <div class="container footer-grid">
        <div>
          <div class="footer-brand">Vontimitta</div>
          <p>Heritage • History • Devotion</p>
        </div>
        <div class="footer-links">
          <button @click="navigate('history')">History</button>
          <button @click="navigate('festival')">Festival</button>
          <button @click="navigate('gallery')">Gallery</button>
          <button @click="navigate('about')">About</button>
        </div>
      </div>
      <div class="footer-bottom">© {{ new Date().getFullYear() }} Vontimitta Heritage • Static Vue.js site</div>
    </footer>

    <button class="floating-top" @click="scrollTop" aria-label="Back to top">↑</button>
  </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { gallery, festivals, timeline, sources } from "./data/content";

const page = ref("home");
const mobileOpen = ref(false);
const activeFilter = ref("All");

const navItems = [
  { id: "home", label: "Home" },
  { id: "history", label: "History" },
  { id: "festival", label: "Festival" },
  { id: "gallery", label: "Gallery" },
  { id: "about", label: "About" }
];

const highlights = [
  { icon: "✦", title: "Ancient Heritage", text: "A historic temple complex celebrated for its stone architecture and sculptures." },
  { icon: "◈", title: "Ekashila Nagaram", text: "Rama, Sita and Lakshmana are traditionally represented together on a single stone." },
  { icon: "❈", title: "Living Festival", text: "Brahmotsavam brings music, rituals, processions and thousands of devotees together." }
];

const featuredPhotos = computed(() => gallery.filter((p) => p.year === "2026").slice(0, 3));
const filters = computed(() => ["All", ...new Set(gallery.map((p) => p.category))]);
const filteredPhotos = computed(() =>
  activeFilter.value === "All"
    ? gallery
    : gallery.filter((p) => p.category === activeFilter.value)
);

function navigate(target) {
  page.value = target;
  mobileOpen.value = false;
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function scrollTop() {
  window.scrollTo({ top: 0, behavior: "smooth" });
}
</script>