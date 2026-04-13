<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Health Chat</title>

  <!-- Bootstrap 5 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <!-- ✅ CHANGE 1: ML + GenAI styles -->
  <link rel="stylesheet" href="css/ml-styles.css">

  <style>
    :root {
      --green-900: #064e3b;
      --green-800: #065f46;
      --green-700: #047857;
      --green-600: #059669;
      --green-500: #10b981;
      --green-400: #34d399;
      --green-300: #6ee7b7;
      --green-200: #a7f3d0;
      --green-100: #d1fae5;
      --green-50:  #ecfdf5;
      --sidebar-bg:     #0a2e1f;
      --sidebar-hover:  rgba(16,185,129,0.12);
      --sidebar-active: rgba(16,185,129,0.2);
      --text-dark:  #0f172a;
      --text-mid:   #334155;
      --text-light: #64748b;
      --border:     #e2f5ec;
      --chat-bg:    #f6fdfb;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { height: 100%; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--chat-bg);
      color: var(--text-dark);
      height: 100vh;
      overflow: hidden;
      display: flex;
    }

    /* =================== SCROLLBAR =================== */
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--green-200); border-radius: 10px; }

    /* =================== SIDEBAR =================== */
    #sidebar {
      width: 280px;
      min-width: 280px;
      background: var(--sidebar-bg);
      display: flex;
      flex-direction: column;
      height: 100vh;
      transition: transform 0.3s ease;
      z-index: 100;
      flex-shrink: 0;
    }

    .sidebar-header {
      padding: 22px 18px 16px;
      border-bottom: 1px solid rgba(255,255,255,0.06);
      flex-shrink: 0;
    }

    .brand-link {
      display: flex; align-items: center; gap: 10px;
      text-decoration: none; margin-bottom: 18px;
    }
    .brand-mark {
      width: 34px; height: 34px;
      background: linear-gradient(135deg, var(--green-600), var(--green-400));
      border-radius: 9px; display: flex; align-items: center;
      justify-content: center; color: #fff; font-size: 15px;
      box-shadow: 0 4px 12px rgba(16,185,129,0.4);
    }
    .brand-name {
      font-family: 'Sora', sans-serif; font-weight: 800; font-size: 17px;
      color: #fff; letter-spacing: -0.3px;
    }

    .form-input-dark {
      width: 100%;
      background: rgba(255,255,255,0.08);
      border: 1px solid rgba(255,255,255,0.12);
      border-radius: 10px;
      padding: 9px 13px;
      font-family: 'DM Sans', sans-serif;
      font-size: 13.5px;
      color: #fff;
      outline: none;
      transition: 0.2s;
      margin-bottom: 8px;
    }
    .form-input-dark::placeholder { color: rgba(255,255,255,0.35); }
    .form-input-dark:focus {
      border-color: var(--green-500);
      background: rgba(16,185,129,0.1);
    }
    /* Chrome autofill fix */
    .form-input-dark:-webkit-autofill {
      -webkit-box-shadow: 0 0 0 30px #0a2e1f inset !important;
      -webkit-text-fill-color: #fff !important;
    }

    .btn-add-patient {
      width: 100%;
      background: linear-gradient(135deg, var(--green-600), var(--green-500));
      color: #fff; border: none; border-radius: 10px;
      padding: 9px; font-family: 'DM Sans', sans-serif;
      font-size: 13.5px; font-weight: 600; cursor: pointer;
      transition: 0.2s; display: flex; align-items: center;
      justify-content: center; gap: 6px;
    }
    .btn-add-patient:hover { background: linear-gradient(135deg, var(--green-700), var(--green-600)); }

    /* Patient List */
    .patients-section {
      flex: 1; overflow-y: auto; padding: 14px 12px;
    }
    .patients-label {
      font-size: 11px; font-weight: 700; letter-spacing: 1.2px;
      text-transform: uppercase; color: rgba(255,255,255,0.35);
      padding: 0 6px; margin-bottom: 8px; display: block;
    }
    #patientList { list-style: none; display: flex; flex-direction: column; gap: 4px; }

    .patient-item {
      display: flex; align-items: center; justify-content: space-between;
      padding: 9px 10px; border-radius: 10px; cursor: pointer;
      transition: 0.2s; border: 1px solid transparent;
    }
    .patient-item:hover { background: var(--sidebar-hover); }
    .patient-item.active {
      background: var(--sidebar-active);
      border-color: rgba(16,185,129,0.3);
    }
    .patient-item-left {
      display: flex; align-items: center; gap: 9px; flex: 1; min-width: 0;
    }
    .patient-avatar {
      width: 30px; height: 30px; border-radius: 50%;
      background: linear-gradient(135deg, var(--green-700), var(--green-500));
      display: flex; align-items: center; justify-content: center;
      font-size: 12px; color: #fff; font-weight: 700; flex-shrink: 0;
    }
    .patient-info { flex: 1; min-width: 0; }
    .patient-name-label {
      font-size: 13.5px; color: rgba(255,255,255,0.88); font-weight: 500;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .patient-age-label { font-size: 11px; color: rgba(255,255,255,0.4); }
    .btn-delete {
      background: none; border: none; color: rgba(255,255,255,0.25);
      cursor: pointer; font-size: 14px; padding: 3px 6px;
      border-radius: 5px; transition: 0.15s; flex-shrink: 0; line-height: 1;
    }
    .btn-delete:hover { color: #f87171; background: rgba(248,113,113,0.12); }

    .no-patients-msg {
      text-align: center; padding: 20px 10px;
      color: rgba(255,255,255,0.25); font-size: 12.5px; line-height: 1.6;
    }

    .sidebar-footer {
      padding: 14px 18px;
      border-top: 1px solid rgba(255,255,255,0.06);
      flex-shrink: 0;
    }
    .back-link {
      display: flex; align-items: center; gap: 7px;
      font-size: 13px; color: rgba(255,255,255,0.4);
      text-decoration: none; transition: 0.2s;
    }
    .back-link:hover { color: var(--green-400); }

    /* =================== MAIN AREA =================== */
    #main {
      flex: 1;
      display: flex;
      flex-direction: column;
      height: 100vh;
      overflow: hidden;
      min-width: 0;
    }

    /* TOPBAR */
    #topbar {
      background: #fff;
      border-bottom: 1px solid var(--border);
      padding: 0 24px;
      height: 72px;
      display: flex; align-items: center; justify-content: space-between;
      box-shadow: 0 1px 8px rgba(6,78,59,0.05);
      flex-shrink: 0;
    }
    .topbar-left { display: flex; align-items: center; gap: 12px; }
    .topbar-avatar {
      width: 38px; height: 38px; border-radius: 50%;
      background: linear-gradient(135deg, var(--green-100), var(--green-200));
      display: flex; align-items: center; justify-content: center;
      font-size: 16px; color: var(--green-700); flex-shrink: 0;
    }
    .topbar-avatar.has-patient {
      background: linear-gradient(135deg, var(--green-600), var(--green-400));
      color: #fff; font-family: 'Sora', sans-serif; font-weight: 700;
    }
    #topbarTitle {
      font-family: 'Sora', sans-serif; font-size: 14px; font-weight: 700;
      color: var(--text-dark);
    }
    #topbarSub { font-size: 12px; color: var(--text-light); }
    .online-badge {
      display: flex; align-items: center; gap: 6px;
      background: #f0fdf4; border: 1px solid #bbf7d0;
      color: var(--green-700); font-size: 12px; font-weight: 600;
      padding: 5px 14px; border-radius: 50px; flex-shrink: 0;
    }
    .online-dot {
      width: 7px; height: 7px; background: var(--green-500);
      border-radius: 50%; animation: pulse 2s infinite;
    }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.4} }

    #sidebarToggle {
      display: none; background: none; border: none;
      font-size: 18px; color: var(--text-mid); cursor: pointer;
      padding: 6px; border-radius: 8px; transition: 0.2s;
    }
    #sidebarToggle:hover { background: var(--green-50); }

    /* =================== CHAT WINDOW =================== */
    #chatWindow {
      flex: 1; overflow-y: auto;
      padding: 24px 20px; display: flex;
      flex-direction: column; gap: 18px;
    }

    .empty-state {
      flex: 1; display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      text-align: center; color: var(--text-light); padding: 40px 20px;
    }
    .empty-icon {
      font-size: 48px; color: var(--green-300); margin-bottom: 16px;
    }
    .empty-state h3 {
      font-family: 'Sora', sans-serif; font-size: 20px;
      color: var(--text-mid); margin-bottom: 8px;
    }
    .empty-state p { font-size: 14px; max-width: 320px; line-height: 1.6; }

    .message-row {
      display: flex; flex-direction: column; max-width: 78%;
    }
    .message-row.user { align-self: flex-end; align-items: flex-end; }
    .message-row.bot  { align-self: flex-start; align-items: flex-start; }

    .bot-header {
      display: flex; align-items: center; gap: 7px; margin-bottom: 5px;
    }
    .bot-icon {
      width: 26px; height: 26px; border-radius: 50%;
      background: linear-gradient(135deg, var(--green-600), var(--green-400));
      display: flex; align-items: center; justify-content: center;
      color: #fff; font-size: 11px; flex-shrink: 0;
    }
    .bot-name {
      font-size: 11.5px; font-weight: 700; color: var(--green-700);
    }

    .bubble {
      padding: 13px 18px; font-size: 14px; line-height: 1.65;
      max-width: 100%; word-break: break-word;
    }
    .bubble.user {
      background: linear-gradient(135deg, var(--green-600), var(--green-500));
      color: #fff; border-radius: 18px 18px 4px 18px;
      box-shadow: 0 4px 14px rgba(5,150,105,0.3);
    }
    .bubble.bot {
      background: #fff; color: var(--text-mid);
      border-radius: 18px 18px 18px 4px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.07);
      border: 1px solid var(--border);
    }
    .bubble.bot b { color: var(--green-800); }
    .bubble.bot ul { padding-left: 18px; margin: 6px 0; }
    .bubble.bot li { margin: 3px 0; }

    .msg-time { font-size: 10.5px; color: var(--text-light); margin-top: 4px; text-align: right; }
    .message-row.bot .msg-time { text-align: left; padding-left: 38px; }

    /* Typing Indicator */
    .typing-indicator {
      display: flex; gap: 5px; align-items: center;
      padding: 14px 18px; background: #fff; border: 1px solid var(--border);
      border-radius: 18px 18px 18px 4px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.07); width: fit-content;
    }
    .typing-indicator span {
      width: 8px; height: 8px; background: var(--green-400);
      border-radius: 50%; animation: typeBounce 1.3s infinite;
    }
    .typing-indicator span:nth-child(2){animation-delay:.18s}
    .typing-indicator span:nth-child(3){animation-delay:.36s}
    @keyframes typeBounce { 0%,60%,100%{transform:translateY(0);opacity:0.45} 30%{transform:translateY(-7px);opacity:1} }

    /* =================== INPUT BAR =================== */
    #inputBar {
      background: #fff; border-top: 1px solid var(--border);
      padding: 14px 20px; display: flex; align-items: flex-end;
      gap: 10px; flex-shrink: 0;
      box-shadow: 0 -2px 12px rgba(6,78,59,0.04);
    }
    #userInput {
      flex: 1; border: 1.5px solid var(--border);
      border-radius: 14px; padding: 11px 16px;
      font-family: 'DM Sans', sans-serif; font-size: 14.5px;
      color: var(--text-dark); outline: none; transition: 0.2s;
      background: var(--chat-bg); resize: none; max-height: 120px;
    }
    #userInput::placeholder { color: var(--text-light); }
    #userInput:focus {
      border-color: var(--green-400); background: #fff;
      box-shadow: 0 0 0 3px rgba(52,211,153,0.12);
    }
    #userInput:disabled { opacity: 0.5; cursor: not-allowed; }

    .input-btn {
      border: none; cursor: pointer; border-radius: 12px;
      height: 44px; display: flex; align-items: center;
      justify-content: center; font-size: 15px; transition: 0.2s;
      font-weight: 600; gap: 6px; flex-shrink: 0;
      font-family: 'DM Sans', sans-serif;
    }
    .btn-send {
      background: var(--green-600); color: #fff;
      padding: 0 20px;
      box-shadow: 0 4px 14px rgba(5,150,105,0.35);
    }
    .btn-send:hover:not(:disabled) { background: var(--green-700); transform: translateY(-1px); }
    .btn-send:disabled { background: #94a3b8; box-shadow: none; cursor: not-allowed; }
    .btn-mic {
      background: #eff6ff; color: #3b82f6; width: 44px;
      border: 1px solid #dbeafe;
    }
    .btn-mic:hover { background: #dbeafe; }
    .btn-mic.listening {
      background: #fef2f2; color: #ef4444; border-color: #fecaca;
      animation: micPulse 1s infinite;
    }
    @keyframes micPulse { 0%,100%{box-shadow:none} 50%{box-shadow:0 0 0 6px rgba(239,68,68,0.15)} }
    .btn-hospital {
      background: #fff5f5; color: #ef4444; width: 44px;
      border: 1px solid #fecaca;
    }
    .btn-hospital:hover { background: #fee2e2; }

    /* No patient warning bar */
    #noPatientBar {
      background: #fffbeb; border-bottom: 1px solid #fde68a;
      padding: 8px 20px; font-size: 13px; color: #78350f;
      text-align: center; flex-shrink: 0; display: none;
    }

    /* =================== TOAST =================== */
    .toast-container-custom {
      position: fixed; top: 16px; right: 16px; z-index: 9999;
      display: flex; flex-direction: column; gap: 8px;
    }
    .toast-item {
      padding: 10px 18px; border-radius: 10px; font-size: 13.5px;
      font-weight: 600; color: #fff; box-shadow: 0 4px 16px rgba(0,0,0,0.15);
      animation: toastSlide 0.3s ease; max-width: 300px;
    }
    .toast-success { background: var(--green-600); }
    .toast-warning { background: #d97706; }
    .toast-error   { background: #dc2626; }
    @keyframes toastSlide { from{opacity:0;transform:translateX(20px)} to{opacity:1;transform:translateX(0)} }

    /* =================== SIDEBAR OVERLAY (mobile) =================== */
    #sidebarOverlay {
      display: none; position: fixed; inset: 0;
      background: rgba(0,0,0,0.5); z-index: 90;
    }

    /* =================== RESPONSIVE =================== */
    @media (max-width: 768px) {
      #sidebar {
        position: fixed; left: 0; top: 0; height: 100%;
        transform: translateX(-100%); z-index: 100;
        box-shadow: none; transition: transform 0.3s ease, box-shadow 0.3s;
      }
      #sidebar.open {
        transform: translateX(0);
        box-shadow: 4px 0 24px rgba(0,0,0,0.2);
      }
      #sidebarOverlay.show { display: block; }
      #sidebarToggle { display: flex !important; align-items: center; }
      #topbar { padding: 0 14px; }
      #chatWindow { padding: 16px 14px; }
      #inputBar { padding: 10px 14px; }
      .bubble { max-width: 85%; }
    }
  </style>
</head>
<body>

<!-- Sidebar Overlay (mobile) -->
<div id="sidebarOverlay"></div>

<!-- Toast Container -->
<div class="toast-container-custom" id="toastContainer"></div>

<!-- =================== SIDEBAR =================== -->
<aside id="sidebar">
  <div class="sidebar-header">
    <a class="brand-link" href="home.jsp">
      <div class="brand-mark"><i class="fa-solid fa-heart-pulse"></i></div>
      <span class="brand-name">MedAI</span>
    </a>
    <input id="patientName" class="form-input-dark" placeholder="Patient name" autocomplete="off">
    <input id="patientAge" type="number" class="form-input-dark" placeholder="Age" min="1" max="120" autocomplete="off">

    <!-- ✅ CHANGE 2: New patient detail fields -->
    <select id="patientGender" class="form-input-dark" style="background:#0a2e1f;color:rgba(255,255,255,0.75);cursor:pointer;">
      <option value="">Gender (optional)</option>
      <option value="Male">Male</option>
      <option value="Female">Female</option>
      <option value="Other">Other</option>
    </select>
    <input id="knownConditions" class="form-input-dark" placeholder="Known conditions (e.g. Diabetes, BP)" autocomplete="off">
    <input id="allergies" class="form-input-dark" placeholder="Allergies (e.g. Penicillin)" autocomplete="off">

    <button type="button" class="btn-add-patient" id="btnAddPatient">
      <i class="fa-solid fa-user-plus"></i> Add Patient
    </button>
  </div>

  <div class="patients-section">
    <span class="patients-label">Patients</span>
    <ul id="patientList"></ul>
  </div>

  <div class="sidebar-footer">
    <a href="home.jsp" class="back-link">
      <i class="fa-solid fa-arrow-left"></i> Back to Home
    </a>
  </div>
</aside>

<!-- =================== MAIN =================== -->
<div id="main">

  <!-- TOP BAR -->
  <div id="topbar">
    <div class="topbar-left">
      <button id="sidebarToggle" title="Toggle sidebar">
        <i class="fa-solid fa-bars"></i>
      </button>
      <div id="topbarAvatar" class="topbar-avatar">
        <i class="fa-solid fa-robot"></i>
      </div>
      <div>
        <div id="topbarTitle">Select a Patient</div>
        <div id="topbarSub">Add or select a patient to begin</div>
      </div>
    </div>
    <!-- ✅ CHANGE 3: Summary Report button added beside AI Online badge -->
    <div style="display:flex;align-items:center;gap:10px;">
      <button class="btn-summary" id="btnSummary" disabled title="Generate a summary report of this patient's consultation">
        &#128203; Summary Report
      </button>
      <div class="online-badge">
        <span class="online-dot"></span> AI Online
      </div>
    </div>
  </div>

  <!-- NO-PATIENT WARNING BAR -->
  <div id="noPatientBar">
    <i class="fa-solid fa-circle-exclamation me-2"></i>
    Please add and select a patient before sending a message.
  </div>

  <!-- ✅ CHANGE 4: Summary Modal -->
  <div id="summaryModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;padding:20px;">
    <div class="summary-card">
      <button class="summary-close-btn" id="btnCloseSummary">&#x2715; Close</button>

      <div id="summaryLoading" class="summary-loading">
        <div class="summary-spinner"></div>
        Generating patient report...
      </div>

      <div id="summaryContent" style="display:none;">
        <div class="summary-title" id="summaryTitle">Health Consultation Summary</div>
        <div class="summary-patient-info" id="summaryPatientInfo"></div>
        <div id="summaryUrgency" class="summary-urgency"></div>

        <div class="summary-section">
          <div class="summary-section-label">Patient Summary</div>
          <div class="summary-section-body" id="sumPatientSummary"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label">Symptoms Reported</div>
          <div class="summary-section-body" id="sumSymptoms"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label">Possible Conditions</div>
          <div class="summary-section-body" id="sumConditions"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label">Medicines Discussed</div>
          <div class="summary-section-body" id="sumMedicines"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label">Precautions Taken</div>
          <div class="summary-section-body" id="sumPrecautions"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label">Follow-up Advice</div>
          <div class="summary-section-body" id="sumFollowUp"></div>
        </div>
        <div class="summary-section">
          <div class="summary-section-label" style="color:rgba(0,0,0,0.3);font-size:10px;">Disclaimer</div>
          <div class="summary-section-body" id="sumDisclaimer" style="color:rgba(0,0,0,0.4);font-size:11px;font-style:italic;"></div>
        </div>
      </div>
    </div>
  </div>

  <!-- CHAT WINDOW -->
  <div id="chatWindow">
    <div class="empty-state" id="emptyState">
      <div class="empty-icon"><i class="fa-solid fa-comment-medical"></i></div>
      <h3>How can I help you?</h3>
      <p>Add a patient profile from the sidebar, then describe your symptoms to get started.</p>
    </div>
  </div>

  <!-- INPUT BAR -->
  <div id="inputBar">
    <textarea
      id="userInput"
      placeholder="Describe your symptoms or ask a health question..."
      rows="1"
      disabled
    ></textarea>
    <button class="input-btn btn-mic" id="micBtn" title="Voice input">
      <i class="fa-solid fa-microphone"></i>
    </button>
    <button class="input-btn btn-hospital" id="btnHospital" title="Find nearby hospitals">
      <i class="fa-solid fa-hospital"></i>
    </button>
    <button class="input-btn btn-send" id="btnSend" disabled>
      <i class="fa-solid fa-paper-plane"></i> Send
    </button>
  </div>

</div>

<!-- jQuery + Bootstrap 5 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/app.js"></script>
</body>
</html>
