/**
 * MedAI — AI Health Assistant
 * app.js — UPDATED with ML + GenAI features
 *
 * NEW additions in this file:
 * 1. addPatient() now reads gender, conditions, allergies fields
 * 2. sendMessage() sends the new patient fields to the servlet
 * 3. renderStructuredResponse() renders JSON AI replies as cards
 * 4. renderRawResponse() is the fallback for non-JSON replies
 * 5. showRiskBadge() and showSymptomTag() render ML results
 * 6. generateSummary() calls SummaryServlet and shows the modal
 * 7. renderSummary() populates the summary modal with AI data
 */

$(function () {

  /* =====================================================
     STATE
  ===================================================== */
  var state = {
    patients:   [],
    chats:      {},
    currentId:  null
  };

  /* =====================================================
     INIT
  ===================================================== */
  function init() {
    try {
      var raw = localStorage.getItem('medai_v2');
      if (raw) {
        var saved    = JSON.parse(raw);
        state.patients = saved.patients || [];
        state.chats    = saved.chats    || {};
      }
    } catch (e) {
      state.patients = [];
      state.chats    = {};
    }
    renderPatientList();
    showNoPatientBar(true);
    bindSummaryButton();  // NEW — wire up the Summary Report button
  }

  /* =====================================================
     PERSIST
  ===================================================== */
  function save() {
    try {
      localStorage.setItem('medai_v2', JSON.stringify({
        patients: state.patients,
        chats:    state.chats
      }));
    } catch (e) {}
  }

  function makeId() {
    return 'p_' + Date.now() + '_' + Math.floor(Math.random() * 10000);
  }

  /* =====================================================
     ADD PATIENT  ← UPDATED: now reads 3 new fields
  ===================================================== */
  function addPatient() {
    var name       = $.trim($('#patientName').val());
    var age        = $.trim($('#patientAge').val());

    // NEW fields — read from the new inputs added to index.jsp
    var gender     = $.trim($('#patientGender').val())       || '';
    var conditions = $.trim($('#knownConditions').val())     || '';
    var allergies  = $.trim($('#allergies').val())           || '';

    if (!name) {
      showToast('Please enter the patient name.', 'warning');
      $('#patientName').focus();
      return;
    }

    var ageNum = parseInt(age, 10);
    if (!age || isNaN(ageNum) || ageNum < 1 || ageNum > 120) {
      showToast('Please enter a valid age between 1 and 120.', 'warning');
      $('#patientAge').focus();
      return;
    }

    var exists = state.patients.some(function (p) {
      return p.name.toLowerCase() === name.toLowerCase() && p.age === ageNum;
    });
    if (exists) {
      showToast('This patient already exists.', 'warning');
      return;
    }

    // Store all fields with the patient object
    var patient = {
      id:         makeId(),
      name:       name,
      age:        ageNum,
      gender:     gender,       // NEW
      conditions: conditions,   // NEW
      allergies:  allergies     // NEW
    };

    state.patients.push(patient);
    state.chats[patient.id] = [];
    save();

    // Clear all inputs including new ones
    $('#patientName').val('');
    $('#patientAge').val('');
    $('#patientGender').val('');
    $('#knownConditions').val('');
    $('#allergies').val('');

    renderPatientList();
    selectPatient(patient.id);
    showToast('Patient added: ' + patient.name, 'success');
  }

  /* =====================================================
     DELETE PATIENT
  ===================================================== */
  function deletePatient(id) {
    state.patients = state.patients.filter(function (p) { return p.id !== id; });
    delete state.chats[id];

    if (state.currentId === id) {
      state.currentId = null;
      resetView();
    }

    save();
    renderPatientList();
    showToast('Patient removed.', 'info');
  }

  /* =====================================================
     SELECT PATIENT
  ===================================================== */
  function selectPatient(id) {
    var patient = state.patients.find(function (p) { return p.id === id; });
    if (!patient) return;

    state.currentId = id;

    // Update topbar
    $('#topbarTitle').text(patient.name);
    $('#topbarSub').text('Age ' + patient.age
      + (patient.gender     ? ' · ' + patient.gender     : '')
      + (patient.conditions ? ' · ' + patient.conditions : ''));
    $('#topbarAvatar').addClass('has-patient');

    // Enable input and summary button
    $('#userInput').prop('disabled', false).focus();
    $('#btnSummary').prop('disabled', false); // NEW — enable summary button

    showNoPatientBar(false);
    loadChat(id, patient.name);
    renderPatientList();
  }

  function resetView() {
    state.currentId = null;
    $('#topbarTitle').text('Select a Patient');
    $('#topbarSub').text('Add or select a patient to begin');
    $('#topbarAvatar').removeClass('has-patient');
    $('#userInput').prop('disabled', true);
    $('#btnSummary').prop('disabled', true); // NEW — disable when no patient
    showNoPatientBar(true);
    $('#chatWindow').html(
      '<div class="empty-state" id="emptyState">' +
        '<div class="empty-icon"><i class="fa-solid fa-comment-medical"></i></div>' +
        '<h3>How can I help you?</h3>' +
        '<p>Add a patient profile from the sidebar, then describe your symptoms to get started.</p>' +
      '</div>'
    );
    renderPatientList();
  }

  /* =====================================================
     RENDER PATIENT LIST
  ===================================================== */
  function renderPatientList() {
    var $list = $('#patientList').empty();

    if (state.patients.length === 0) {
      $list.append('<li class="no-patients-msg">No patients yet.<br>Add one above.</li>');
      return;
    }

    $.each(state.patients, function (i, patient) {
      var isActive = (patient.id === state.currentId);
      var initials = patient.name.charAt(0).toUpperCase();

      var $item = $('<li class="patient-item' + (isActive ? ' active' : '') + '"></li>');
      $item.html(
        '<div class="patient-item-left" onclick="window.selectPatient(\'' + patient.id + '\')">' +
          '<div class="patient-avatar">' + initials + '</div>' +
          '<div class="patient-info">' +
            '<div class="patient-name-label">' + $('<span>').text(patient.name).html() + '</div>' +
            '<div class="patient-age-label">Age ' + patient.age +
              (patient.gender ? ' · ' + patient.gender : '') + '</div>' +
          '</div>' +
        '</div>' +
        '<button class="delete-patient-btn" title="Remove patient" onclick="window.removePatient(\'' + patient.id + '\')">' +
          '<i class="fa-solid fa-trash-can"></i>' +
        '</button>'
      );
      $list.append($item);
    });
  }

  // Expose to inline onclick handlers
  window.selectPatient = selectPatient;
  window.removePatient = deletePatient;

  /* =====================================================
     LOAD CHAT
  ===================================================== */
  function loadChat(id, patientName) {
    var history = state.chats[id] || [];
    $('#chatWindow').empty();

    if (history.length === 0) {
      renderWelcome(patientName);
      return;
    }

    $.each(history, function (i, msg) {
      if (msg.sender === 'user') {
        appendUserMsg(msg.text, msg.time, false);
      } else {
        appendBotMsg(msg.text, msg.time, false);
      }
    });

    scrollToBottom();
  }

  function renderWelcome(name) {
    $('#chatWindow').html(
      '<div class="empty-state" id="emptyState">' +
        '<div class="empty-icon"><i class="fa-solid fa-comment-medical"></i></div>' +
        '<h3>Hello, ' + $('<span>').text(name).html() + '!</h3>' +
        '<p>Describe your symptoms and I\'ll help analyze them using AI + ML.</p>' +
      '</div>'
    );
  }

  /* =====================================================
     APPEND MESSAGES
  ===================================================== */
  function appendBotMsg(html, time, doScroll) {
    $('#emptyState').remove();
    var timeStr = time || getTime();
    var $row = $(
      '<div class="msg-row bot-row">' +
        '<div class="msg-avatar"><i class="fa-solid fa-robot"></i></div>' +
        '<div class="msg-bubble bot-bubble">' + html + '</div>' +
        '<div class="msg-time">' + timeStr + '</div>' +
      '</div>'
    );
    $('#chatWindow').append($row);
    if (doScroll !== false) scrollToBottom();
  }

  function appendUserMsg(text, time, doScroll) {
    $('#emptyState').remove();
    var timeStr = time || getTime();
    var $row = $(
      '<div class="msg-row user-row">' +
        '<div class="msg-bubble user-bubble">' + $('<span>').text(text).html() + '</div>' +
        '<div class="msg-time">' + timeStr + '</div>' +
      '</div>'
    );
    $('#chatWindow').append($row);
    if (doScroll !== false) scrollToBottom();
  }

  function addMessage(sender, content) {
    if (!state.currentId) return;
    var msg = { sender: sender, text: content, time: getTime() };
    state.chats[state.currentId].push(msg);
    save();
  }

  function showTyping() {
    $('#chatWindow').append(
      '<div id="typingRow" class="msg-row bot-row">' +
        '<div class="msg-avatar"><i class="fa-solid fa-robot"></i></div>' +
        '<div class="msg-bubble bot-bubble typing-bubble">' +
          '<span class="typing-dot"></span>' +
          '<span class="typing-dot"></span>' +
          '<span class="typing-dot"></span>' +
        '</div>' +
      '</div>'
    );
    scrollToBottom();
  }

  function removeTyping() { $('#typingRow').remove(); }

  /* =====================================================
     SEND MESSAGE  ← UPDATED: sends new patient fields
  ===================================================== */
  function sendMessage() {
    var text = $.trim($('#userInput').val());
    if (!text || !state.currentId) return;

    var patient = state.patients.find(function (p) { return p.id === state.currentId; });
    if (!patient) return;

    $('#userInput').val('').css('height', 'auto');
    appendUserMsg(text, null, true);
    addMessage('user', text);
    showTyping();

    $.ajax({
      url:    'ChatbotServlet',
      method: 'POST',
      data: {
        patientName:     patient.name,
        patientAge:      patient.age,
        patientGender:   patient.gender     || '',  // NEW
        knownConditions: patient.conditions || '',  // NEW
        allergies:       patient.allergies  || '',  // NEW
        question:        text
      },
      dataType: 'json',

      success: function (data) {
        removeTyping();

        if (data.status === 'error') {
          appendBotMsg('<span style="color:#F09595;">' + data.reply + '</span>', null, true);
          return;
        }

        // ── NEW: Build the full bot message HTML ───────────────────────
        var fullHtml = '';

        // Show symptom category tag (ML result)
        if (data.symptomCategory) {
          fullHtml += buildSymptomTag(data.symptomCategory, data.confidenceScore);
        }

        // Show risk badge (ML result)
        if (data.riskLevel) {
          fullHtml += buildRiskBadge(data.riskLevel);
        }

        // Show AI response — structured cards or raw fallback
        if (data.structured && typeof data.reply === 'object') {
          fullHtml += buildStructuredCards(data.reply);
        } else {
          fullHtml += '<div>' + (data.reply || 'No response.') + '</div>';
        }

        // Show risk advice bar at the bottom
        if (data.riskAdvice) {
          fullHtml += buildRiskAdviceBar(data.riskLevel, data.riskAdvice);
        }

        appendBotMsg(fullHtml, null, true);
        addMessage('bot', fullHtml);
      },

      error: function () {
        removeTyping();
        appendBotMsg('<span style="color:#F09595;">Connection error. Please check your network.</span>', null, true);
      }
    });
  }

  /* =====================================================
     ML UI BUILDERS  ← NEW FUNCTIONS
  ===================================================== */

  /**
   * buildSymptomTag()
   * Renders the ML symptom classification result as a pill tag.
   * Example: 🫁 Respiratory · 73% confidence
   */
  function buildSymptomTag(category, confidence) {
    var icons = {
      'Respiratory':     '&#x1FAC1;',  // 🫁
      'Digestive':       '&#x1F9E0;',  // 🧠 (no stomach emoji, using brain)
      'Neurological':    '&#x1F9E0;',  // 🧠
      'Cardiovascular':  '&#x2764;',   // ❤
      'Skin':            '&#x1F9B4;',  // 🦴 (approximation)
      'Musculoskeletal': '&#x1F9B4;',  // 🦴
      'General':         '&#x2695;'    // ⚕
    };
    var icon = icons[category] || '⚕';
    var confText = confidence && confidence > 0 ? ' &middot; ' + confidence + '% match' : '';
    return '<div class="symptom-tag ' + category + '">' + icon + ' ' + category + confText + '</div>';
  }

  /**
   * buildRiskBadge()
   * Renders the ML risk score badge: LOW / MEDIUM / HIGH
   */
  function buildRiskBadge(level) {
    var labels = { 'LOW': '🟢 LOW RISK', 'MEDIUM': '🟡 MEDIUM RISK', 'HIGH': '🔴 HIGH RISK' };
    var label  = labels[level] || level;
    return '<div class="risk-badge ' + level + '"><span class="risk-dot"></span>' + label + '</div>';
  }

  /**
   * buildRiskAdviceBar()
   * Renders the colored advice strip at the bottom of the response.
   */
  function buildRiskAdviceBar(level, advice) {
    return '<div class="risk-advice-bar ' + level + '">' + advice + '</div>';
  }

  /**
   * buildStructuredCards()
   * GenAI Feature: Renders the AI's JSON response as structured cards.
   * Each medical section gets its own card.
   *
   * @param reply - parsed JSON object from the AI
   */
  function buildStructuredCards(reply) {
    var html = '<div class="ai-response-cards">';

    // Greeting
    if (reply.greeting) {
      html += '<div class="ai-greeting">' + $('<span>').text(reply.greeting).html() + '</div>';
    }

    // Possible Conditions card
    if (reply.possibleConditions && reply.possibleConditions.length > 0) {
      html += buildCard('conditions', '&#x1F50D; Possible Conditions', arrayToList(reply.possibleConditions));
    }

    // Precautions card
    if (reply.precautions && reply.precautions.length > 0) {
      html += buildCard('precautions', '&#x26A0; Precautions', arrayToList(reply.precautions));
    }

    // Medicines card
    if (reply.medicines && reply.medicines.length > 0) {
      html += buildCard('medicines', '&#x1F48A; Common Medicines', arrayToList(reply.medicines));
    }

    // When to see a doctor card
    if (reply.whenToSeeDoctor) {
      html += buildCard('doctor', '&#x1F3E5; When to See a Doctor',
        '<p>' + $('<span>').text(reply.whenToSeeDoctor).html() + '</p>');
    }

    // Disclaimer
    if (reply.disclaimer) {
      html += '<div class="ai-disclaimer">' + $('<span>').text(reply.disclaimer).html() + '</div>';
    }

    html += '</div>';
    return html;
  }

  /** Helper: builds one response card */
  function buildCard(type, title, bodyHtml) {
    return (
      '<div class="response-card ' + type + '">' +
        '<div class="card-header"><span class="card-icon"></span>' + title + '</div>' +
        '<div class="card-body">' + bodyHtml + '</div>' +
      '</div>'
    );
  }

  /** Helper: converts a JSON array of strings to an HTML <ul> list */
  function arrayToList(arr) {
    if (!arr || arr.length === 0) return '';
    var items = arr.map(function (item) {
      return '<li>' + $('<span>').text(item).html() + '</li>';
    }).join('');
    return '<ul>' + items + '</ul>';
  }

  /* =====================================================
     GENERATE SUMMARY  ← NEW FEATURE
     GenAI Concept: Text Summarization
  ===================================================== */

  /** Bind the summary button click */
  function bindSummaryButton() {
    $('#btnSummary').on('click', function () {
      generateSummary();
    });

    $('#btnCloseSummary').on('click', function () {
      $('#summaryModal').hide();
    });

    // Close modal when clicking outside the card
    $('#summaryModal').on('click', function (e) {
      if ($(e.target).is('#summaryModal')) {
        $(this).hide();
      }
    });
  }

  /** Call SummaryServlet and show the summary modal */
  function generateSummary() {
    if (!state.currentId) return;

    var patient = state.patients.find(function (p) { return p.id === state.currentId; });
    if (!patient) return;

    var history = state.chats[state.currentId] || [];
    if (history.length === 0) {
      showToast('No messages to summarize. Have a conversation first!', 'warning');
      return;
    }

    // Show the modal in loading state
    $('#summaryLoading').show();
    $('#summaryContent').hide();
    $('#summaryModal').css('display', 'flex');

    // Call the SummaryServlet
    $.ajax({
      url:    'SummaryServlet',
      method: 'POST',
      data: {
        patientName:     patient.name,
        patientAge:      patient.age,
        patientGender:   patient.gender     || '',
        knownConditions: patient.conditions || '',
        allergies:       patient.allergies  || '',
        chatHistory:     JSON.stringify(history)  // Send full history as JSON string
      },
      dataType: 'json',

      success: function (data) {
        $('#summaryLoading').hide();

        if (data.status === 'error') {
          $('#summaryContent').show();
          $('#sumPatientSummary').html('<span style="color:#F09595;">' + data.reply + '</span>');
          return;
        }

        if (data.structured && data.summary) {
          renderSummary(data.summary, patient);
        } else {
          // Fallback: show raw text
          $('#sumPatientSummary').text(data.summary || 'Summary unavailable.');
          $('#summaryContent').show();
        }
      },

      error: function () {
        $('#summaryLoading').hide();
        $('#summaryContent').show();
        $('#sumPatientSummary').html('<span style="color:#F09595;">Connection error. Could not generate summary.</span>');
      }
    });
  }

  /**
   * renderSummary()
   * Populates the summary modal with the structured AI response.
   *
   * @param s       - the summary JSON object from SummaryServlet
   * @param patient - the patient object
   */
  function renderSummary(s, patient) {
    // Patient info
    $('#summaryTitle').text(s.reportTitle || 'Health Consultation Summary');
    $('#summaryPatientInfo').text(
      patient.name + ' · Age ' + patient.age +
      (patient.gender     ? ' · ' + patient.gender     : '') +
      (patient.conditions ? ' · Conditions: ' + patient.conditions : '')
    );

    // Urgency strip
    var urgency = (s.urgencyAssessment || '').toUpperCase();
    var urgencyLevel = urgency.includes('HIGH') ? 'HIGH'
                     : urgency.includes('MEDIUM') ? 'MEDIUM' : 'LOW';
    $('#summaryUrgency')
      .removeClass('LOW MEDIUM HIGH')
      .addClass(urgencyLevel)
      .text('Urgency: ' + (s.urgencyAssessment || urgencyLevel));

    // Sections
    $('#sumPatientSummary').text(s.patientSummary || '');
    $('#sumSymptoms').html(arrayToList(s.symptomsReported));
    $('#sumConditions').html(arrayToList(s.possibleConditions));
    $('#sumMedicines').html(arrayToList(s.medicinesDiscussed));
    $('#sumPrecautions').html(arrayToList(s.precautionsTaken));
    $('#sumFollowUp').text(s.followUpAdvice || '');
    $('#sumDisclaimer').text(s.disclaimer || '');

    $('#summaryContent').show();
  }

  /* =====================================================
     VOICE INPUT (unchanged from original)
  ===================================================== */
  function startVoice() {
    var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
      showToast('Voice input not supported in this browser.', 'warning');
      return;
    }
    var rec  = new SpeechRecognition();
    var $btn = $('#micBtn');
    rec.lang        = 'en-US';
    rec.interimResults = false;
    rec.onstart     = function () { $btn.addClass('listening'); };
    rec.onend       = function () { $btn.removeClass('listening'); };
    rec.onresult    = function (e) {
      $('#userInput').val(e.results[0][0].transcript);
    };
    rec.onerror     = function (e) {
      showToast('Voice error: ' + e.error, 'warning');
      $btn.removeClass('listening');
    };
    rec.start();
  }

  /* =====================================================
     UTILITY FUNCTIONS
  ===================================================== */
  function scrollToBottom() {
    var el = document.getElementById('chatWindow');
    if (el) el.scrollTop = el.scrollHeight;
  }

  function getTime() {
    var now = new Date();
    var h   = now.getHours();
    var m   = String(now.getMinutes()).padStart(2, '0');
    var ap  = h >= 12 ? 'PM' : 'AM';
    h = h % 12 || 12;
    return h + ':' + m + ' ' + ap;
  }

  function showNoPatientBar(show) {
    $('#noPatientBar').toggle(show);
  }

  function showToast(msg, type) {
    var colors = {
      success: '#27500A',
      warning: '#633806',
      info:    '#185FA5',
      error:   '#791F1F'
    };
    var bg = colors[type] || colors.info;
    var $t = $(
      '<div class="toast-custom" style="background:' + bg + ';color:#fff;' +
      'padding:10px 16px;border-radius:10px;font-size:13px;margin-bottom:8px;' +
      'box-shadow:0 4px 12px rgba(0,0,0,0.3);">' + msg + '</div>'
    );
    $('#toastContainer').append($t);
    setTimeout(function () { $t.fadeOut(300, function () { $t.remove(); }); }, 3000);
  }

  /* =====================================================
     EVENT BINDINGS
  ===================================================== */
  $('#btnAddPatient').on('click', addPatient);

  $('#userInput').on('keydown', function (e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  // Auto-resize textarea
  $('#userInput').on('input', function () {
    this.style.height = 'auto';
    this.style.height = Math.min(this.scrollHeight, 120) + 'px';
  });

  $('#btnSend').on('click', sendMessage);
  $('#micBtn').on('click', startVoice);

  // Hospital button — opens Google Maps with nearby hospitals
  $('#btnHospital').on('click', function () {
    if (!navigator.geolocation) {
      showToast('Geolocation not supported in this browser.', 'warning');
      return;
    }
    navigator.geolocation.getCurrentPosition(
      function (pos) {
        window.open(
          'https://www.google.com/maps/search/hospital/@' +
          pos.coords.latitude + ',' + pos.coords.longitude + ',15z', '_blank'
        );
      },
      function () {
        showToast('Location access denied. Please allow location and retry.', 'warning');
      }
    );
  });

  // Sidebar toggle (mobile)
  $('#sidebarToggle').on('click', function () {
    $('#sidebar').toggleClass('open');
    $('#sidebarOverlay').toggleClass('show');
  });
  $('#sidebarOverlay').on('click', function () {
    $('#sidebar').removeClass('open');
    $(this).removeClass('show');
  });

  /* =====================================================
     START
  ===================================================== */
  init();
});
