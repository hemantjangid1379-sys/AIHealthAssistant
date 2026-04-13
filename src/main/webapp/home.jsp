<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ai health assistant</title>

  <!-- Bootstrap 5 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">

  <style>
    :root {
      --green-900: #064e3b;
      --green-800: #065f46;
      --green-700: #047857;
      --green-600: #059669;
      --green-500: #10b981;
      --green-400: #34d399;
      --green-100: #d1fae5;
      --green-50:  #ecfdf5;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body { font-family: 'DM Sans', sans-serif; color: #0f172a; overflow-x: hidden; }

    /* NAV */
    .navbar-brand-custom {
      display: flex; align-items: center; gap: 10px;
      font-family: 'Sora', sans-serif; font-weight: 800; font-size: 22px;
      color: var(--green-800) !important; text-decoration: none;
    }
    .brand-mark {
      width: 40px; height: 40px;
      background: linear-gradient(135deg, var(--green-600), var(--green-400));
      border-radius: 11px; display: flex; align-items: center;
      justify-content: center; color: #fff; font-size: 18px;
      box-shadow: 0 4px 12px rgba(16,185,129,0.4);
    }
    .navbar-custom {
      background: rgba(255,255,255,0.95) !important;
      backdrop-filter: blur(16px);
      border-bottom: 1px solid rgba(16,185,129,0.14);
      transition: box-shadow 0.3s;
      min-height: 80px;
      padding-top: 0 !important;
      padding-bottom: 0 !important;
    }
    .navbar-custom .container {
      min-height: 80px;
      display: flex;
      align-items: center;
    }
    .navbar-custom.scrolled { box-shadow: 0 4px 24px rgba(6,78,59,0.1); }
    .nav-link-custom {
      font-size: 15px; font-weight: 500; color: #334155 !important;
      transition: color 0.2s; padding: 6px 8px !important;
      letter-spacing: 0.1px;
    }
    .nav-link-custom:hover { color: var(--green-600) !important; }
    .btn-nav-cta {
      background: var(--green-600); color: #fff !important;
      padding: 11px 26px; border-radius: 50px;
      font-size: 14px; font-weight: 600; text-decoration: none;
      transition: all 0.2s; letter-spacing: 0.2px;
    }
    .btn-nav-cta:hover { background: var(--green-700); transform: translateY(-1px); }

    /* HERO */
    .hero-section {
      min-height: 100vh;
      background: linear-gradient(135deg, #ecfdf5 0%, #f0fdfa 50%, #eff6ff 100%);
      display: flex; align-items: center; padding-top: 80px;
    }
    .hero-badge {
      display: inline-flex; align-items: center; gap: 8px;
      background: #d1fae5; color: var(--green-800);
      padding: 6px 16px; border-radius: 50px;
      font-size: 13px; font-weight: 600; margin-bottom: 24px;
    }
    .hero-badge-dot {
      width: 7px; height: 7px; background: var(--green-500);
      border-radius: 50%; animation: blink 2s infinite;
    }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.3} }
    .hero-title {
      font-family: 'Sora', sans-serif; font-size: clamp(36px, 5vw, 62px);
      font-weight: 800; line-height: 1.1; color: #0f172a; margin-bottom: 24px;
    }
    .hero-title span { color: var(--green-600); }
    .hero-sub {
      font-size: 18px; color: #475569; line-height: 1.7; margin-bottom: 36px; max-width: 520px;
    }
    .btn-hero-primary {
      background: var(--green-600); color: #fff;
      padding: 14px 32px; border-radius: 14px; font-size: 16px;
      font-weight: 700; text-decoration: none; display: inline-flex;
      align-items: center; gap: 10px;
      box-shadow: 0 8px 24px rgba(5,150,105,0.35);
      transition: all 0.2s;
    }
    .btn-hero-primary:hover { background: var(--green-700); transform: translateY(-2px); color: #fff; }
    .btn-hero-secondary {
      background: #fff; color: #334155;
      padding: 14px 32px; border-radius: 14px; font-size: 16px;
      font-weight: 600; text-decoration: none; display: inline-flex;
      align-items: center; gap: 10px;
      border: 1.5px solid #e2e8f0;
      transition: all 0.2s;
    }
    .btn-hero-secondary:hover { border-color: var(--green-400); color: var(--green-700); }

    /* CHAT PREVIEW CARD */
    .hero-card {
      background: #fff; border-radius: 24px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.12), 0 0 0 1px rgba(16,185,129,0.08);
      overflow: hidden; max-width: 420px; margin: 0 auto;
    }
    .hero-card-header {
      background: #0a2e1f; padding: 16px 20px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .hero-card-dots span {
      display: inline-block; width: 10px; height: 10px;
      border-radius: 50%; margin-right: 6px;
    }
    .dot-red { background: #ff5f57; }
    .dot-yellow { background: #ffbd2e; }
    .dot-green { background: #28c840; }
    .hero-card-title { color: rgba(255,255,255,0.7); font-size: 13px; font-weight: 500; }
    .hero-card-body { padding: 20px; display: flex; flex-direction: column; gap: 12px; }
    .preview-msg {
      max-width: 82%; padding: 11px 15px; border-radius: 16px;
      font-size: 13.5px; line-height: 1.5;
    }
    .preview-msg.bot {
      background: #f8fafc; border: 1px solid #e2e8f0;
      color: #334155; border-radius: 16px 16px 16px 4px;
    }
    .preview-msg.user {
      background: var(--green-600); color: #fff;
      border-radius: 16px 16px 4px 16px; margin-left: auto;
    }
    .preview-typing {
      display: flex; gap: 5px; align-items: center;
      background: #f8fafc; border: 1px solid #e2e8f0;
      border-radius: 16px; padding: 12px 16px; width: fit-content;
    }
    .preview-typing span {
      width: 7px; height: 7px; background: var(--green-400);
      border-radius: 50%; animation: typeBounce 1.3s infinite;
    }
    .preview-typing span:nth-child(2){animation-delay:.18s}
    .preview-typing span:nth-child(3){animation-delay:.36s}
    @keyframes typeBounce { 0%,60%,100%{transform:translateY(0);opacity:0.4} 30%{transform:translateY(-7px);opacity:1} }

    /* STATS */
    .stats-section { background: #fff; padding: 64px 0; }
    .stat-card {
      text-align: center; padding: 32px 20px;
      border-radius: 20px; background: var(--green-50);
      border: 1px solid var(--green-100);
      transition: transform 0.2s;
    }
    .stat-card:hover { transform: translateY(-4px); }
    .stat-num {
      font-family: 'Sora', sans-serif; font-size: 38px;
      font-weight: 800; color: var(--green-700);
    }
    .stat-label { font-size: 14px; color: #64748b; margin-top: 6px; }

    /* FEATURES */
    .features-section { background: #f8fafc; padding: 88px 0; }
    .section-badge {
      display: inline-block; background: var(--green-100);
      color: var(--green-800); padding: 5px 16px;
      border-radius: 50px; font-size: 13px; font-weight: 700;
      margin-bottom: 16px;
    }
    .section-title {
      font-family: 'Sora', sans-serif; font-size: clamp(28px, 4vw, 42px);
      font-weight: 800; color: #0f172a; margin-bottom: 16px;
    }
    .feature-card {
      background: #fff; border-radius: 20px; padding: 32px;
      border: 1px solid #e2e8f0; height: 100%;
      transition: all 0.25s;
    }
    .feature-card:hover {
      border-color: var(--green-300); box-shadow: 0 8px 30px rgba(16,185,129,0.1);
      transform: translateY(-4px);
    }
    .feature-icon {
      width: 52px; height: 52px; border-radius: 14px;
      background: var(--green-50); display: flex; align-items: center;
      justify-content: center; font-size: 22px; color: var(--green-600);
      margin-bottom: 18px;
    }
    .feature-title { font-family: 'Sora', sans-serif; font-size: 17px; font-weight: 700; margin-bottom: 10px; }
    .feature-desc { font-size: 14px; color: #64748b; line-height: 1.65; }

    /* HOW IT WORKS */
    .how-section { background: #fff; padding: 88px 0; }
    .step-num {
      width: 44px; height: 44px; border-radius: 50%;
      background: var(--green-600); color: #fff;
      font-family: 'Sora', sans-serif; font-size: 18px; font-weight: 800;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .step-title { font-family: 'Sora', sans-serif; font-size: 17px; font-weight: 700; margin-bottom: 8px; }
    .step-desc { font-size: 14px; color: #64748b; line-height: 1.65; }

    /* CTA */
    .cta-section {
      background: linear-gradient(135deg, var(--green-900), var(--green-700));
      padding: 88px 0; color: #fff; text-align: center;
    }
    .cta-title {
      font-family: 'Sora', sans-serif; font-size: clamp(28px, 4vw, 46px);
      font-weight: 800; margin-bottom: 18px;
    }
    .cta-sub { font-size: 18px; color: rgba(255,255,255,0.75); margin-bottom: 36px; }
    .btn-cta-white {
      background: #fff; color: var(--green-800);
      padding: 15px 40px; border-radius: 14px; font-size: 16px;
      font-weight: 700; text-decoration: none;
      box-shadow: 0 8px 24px rgba(0,0,0,0.2); transition: all 0.2s;
      display: inline-flex; align-items: center; gap: 10px;
    }
    .btn-cta-white:hover { transform: translateY(-2px); color: var(--green-800); }

    /* FOOTER */
    footer {
      background: #0f172a; color: rgba(255,255,255,0.5);
      padding: 40px 0; text-align: center; font-size: 14px;
    }
    footer a { color: var(--green-400); text-decoration: none; }

    /* DISCLAIMER BANNER */
    .disclaimer-banner {
      background: #fffbeb; border-top: 3px solid #fbbf24;
      padding: 14px 24px; font-size: 13px; color: #78350f;
      text-align: center;
    }
  </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-custom fixed-top" id="mainNav">
  <div class="container">
    <a class="navbar-brand-custom" href="home.jsp">
      <div class="brand-mark"><i class="fa-solid fa-heart-pulse"></i></div>
      MedAI
    </a>
    <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu"
            aria-controls="navMenu" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav ms-auto align-items-center gap-2 py-3 py-lg-0">
        <li class="nav-item"><a class="nav-link-custom" href="#features">Features</a></li>
        <li class="nav-item"><a class="nav-link-custom" href="#how-it-works">How It Works</a></li>
        <li class="nav-item ms-3">
          <a class="btn-nav-cta" href="index.jsp">
            <i class="fa-solid fa-stethoscope me-2"></i>Start Consultation
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="hero-section">
  <div class="container">
    <div class="row align-items-center g-5">
      <div class="col-lg-6">
        <div class="hero-badge">
          <span class="hero-badge-dot"></span>
          AI-Powered Health Assistant
        </div>
        <h1 class="hero-title">
          Your Personal<br>
          <span>AI Health</span><br>
          Companion
        </h1>
        <p class="hero-sub">
          Describe your symptoms and get instant AI-powered health insights,
          possible conditions, precautions, and dietary advice.
          Available 24/7 for the whole family.
        </p>
        <div class="d-flex flex-wrap gap-3">
          <a href="index.jsp" class="btn-hero-primary">
            <i class="fa-solid fa-comment-medical"></i> Start Consultation
          </a>
          <a href="#how-it-works" class="btn-hero-secondary">
            <i class="fa-solid fa-circle-play"></i> See How It Works
          </a>
        </div>
        <div class="disclaimer-banner mt-4 rounded-3">
          <i class="fa-solid fa-triangle-exclamation me-2"></i>
          For informational purposes only. Always consult a qualified medical professional for diagnosis and treatment.
        </div>
      </div>
      <div class="col-lg-6 d-flex justify-content-center">
        <div class="hero-card w-100">
          <div class="hero-card-header">
            <div class="hero-card-dots">
              <span class="dot-red"></span>
              <span class="dot-yellow"></span>
              <span class="dot-green"></span>
            </div>
            <span class="hero-card-title">MedAI Chat</span>
            <div></div>
          </div>
          <div class="hero-card-body">
            <div class="preview-msg bot">
              Hello Rajesh! I am your MedAI assistant. Please describe your symptoms so I can help you.
            </div>
            <div class="preview-msg user">
              I have a bad headache and fever since yesterday.
            </div>
            <div class="preview-typing">
              <span></span><span></span><span></span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="stats-section">
  <div class="container">
    <div class="row g-4 text-center">
      <div class="col-6 col-md-3">
        <div class="stat-card">
          <div class="stat-num">24/7</div>
          <div class="stat-label">Always Available</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="stat-card">
          <div class="stat-num">100+</div>
          <div class="stat-label">Symptoms Covered</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="stat-card">
          <div class="stat-num">AI</div>
          <div class="stat-label">Powered by LLaMA 3</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="stat-card">
          <div class="stat-num">Free</div>
          <div class="stat-label">Always Free to Use</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="features-section" id="features">
  <div class="container">
    <div class="text-center mb-5">
      <span class="section-badge">Features</span>
      <h2 class="section-title">Everything You Need</h2>
      <p class="text-muted" style="font-size:16px; max-width:520px; margin:0 auto">
        MedAI provides comprehensive health insights to help you understand your symptoms better.
      </p>
    </div>
    <div class="row g-4">
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-users"></i></div>
          <div class="feature-title">Multi-Patient Support</div>
          <div class="feature-desc">Add and manage multiple family members. Each patient has their own separate chat history, just like WhatsApp.</div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-robot"></i></div>
          <div class="feature-title">AI-Powered Diagnosis</div>
          <div class="feature-desc">Powered by LLaMA 3.1 via Groq API. Get structured responses covering possible conditions, precautions, and medicines.</div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
          <div class="feature-title">Persistent Chat History</div>
          <div class="feature-desc">Your chat history is saved locally. Switch between patients and all previous conversations are preserved automatically.</div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-microphone"></i></div>
          <div class="feature-title">Voice Input</div>
          <div class="feature-desc">Speak your symptoms instead of typing. Supports English and Indian English via the Web Speech API in Chrome.</div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-hospital"></i></div>
          <div class="feature-title">Find Nearby Hospitals</div>
          <div class="feature-desc">One tap to locate hospitals near you using Google Maps. Useful when symptoms require immediate professional attention.</div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-mobile-screen"></i></div>
          <div class="feature-title">Fully Responsive</div>
          <div class="feature-desc">Works perfectly on mobile phones, tablets, and desktops. Clean Bootstrap 5 layout adapts to any screen size.</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- HOW IT WORKS -->
<section class="how-section" id="how-it-works">
  <div class="container">
    <div class="text-center mb-5">
      <span class="section-badge">Simple Process</span>
      <h2 class="section-title">How It Works</h2>
    </div>
    <div class="row g-5 justify-content-center">
      <div class="col-md-10 col-lg-8">
        <div class="d-flex flex-column gap-4">
          <div class="d-flex gap-4 align-items-start">
            <div class="step-num flex-shrink-0">1</div>
            <div>
              <div class="step-title">Add a Patient Profile</div>
              <div class="step-desc">Enter the patient's name and age in the sidebar. You can add multiple family members and switch between them anytime.</div>
            </div>
          </div>
          <div class="d-flex gap-4 align-items-start">
            <div class="step-num flex-shrink-0">2</div>
            <div>
              <div class="step-title">Describe the Symptoms</div>
              <div class="step-desc">Type or speak your symptoms in the chat input. Be as descriptive as possible for the best AI response.</div>
            </div>
          </div>
          <div class="d-flex gap-4 align-items-start">
            <div class="step-num flex-shrink-0">3</div>
            <div>
              <div class="step-title">Get AI Health Insights</div>
              <div class="step-desc">MedAI analyzes your symptoms and returns structured advice including possible conditions, precautions, medicines, and when to see a doctor.</div>
            </div>
          </div>
          <div class="d-flex gap-4 align-items-start">
            <div class="step-num flex-shrink-0">4</div>
            <div>
              <div class="step-title">Consult a Real Doctor</div>
              <div class="step-desc">Use the insights as a starting point. Always follow up with a qualified healthcare professional for proper diagnosis and treatment.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cta-section">
  <div class="container">
    <h2 class="cta-title">Ready to Get Started?</h2>
    <p class="cta-sub">Get instant AI health insights for your whole family, completely free.</p>
    <a href="index.jsp" class="btn-cta-white">
      <i class="fa-solid fa-comment-medical"></i> Start Your Consultation Now
    </a>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="container">
    <p class="mb-2">
      <strong style="color:rgba(255,255,255,0.8);">MedAI</strong> - AI Health Assistant
    </p>
    <p>
      Built with Java JSP/Servlet, Bootstrap 5, and LLaMA 3 via Groq API.<br>
      <span style="color:#fbbf24;">Disclaimer:</span> This tool is for informational purposes only and is not a substitute for professional medical advice.
    </p>
  </div>
</footer>

<!-- Bootstrap 5 JS + jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Navbar scroll effect
  $(window).on('scroll', function () {
    if ($(this).scrollTop() > 40) {
      $('#mainNav').addClass('scrolled');
    } else {
      $('#mainNav').removeClass('scrolled');
    }
  });
</script>
</body>
</html>
