/**
 * validation.js  –  PokerShop
 * Validazione lato client con regex per tutti i form del sito.
 * Verifica disponibilità email in tempo reale tramite AJAX (Fetch API).
 *
 * Moduli:
 *  1. Utility generali (showError / clearError / debounce)
 *  2. Validazione form Registrazione  → #registrazioneForm
 *  3. Verifica email AJAX             → input#email in registrazioneForm
 *  4. Validazione form Login          → #loginForm
 *  5. Validazione form Modifica profilo (area riservata) → #editForm
 */

"use strict";

/* ═══════════════════════════════════════════════════════════════════════════
   1.  UTILITY
═══════════════════════════════════════════════════════════════════════════ */

/**
 * Mostra un messaggio di errore sotto il campo indicato.
 * Aggiunge la classe CSS "input-error" all'input per evidenziarlo.
 * @param {HTMLElement} input  – il campo a cui appartiene l'errore
 * @param {string}      msg    – testo del messaggio
 */
function showError(input, msg) {
    clearError(input);                          // evita duplicati
    input.classList.add("input-error");

    const span = document.createElement("span");
    span.className = "field-error";
    span.textContent = msg;
    span.setAttribute("aria-live", "polite");
    input.insertAdjacentElement("afterend", span);
}

/**
 * Rimuove il messaggio di errore relativo a un campo.
 */
function clearError(input) {
    input.classList.remove("input-error");
    const next = input.nextElementSibling;
    if (next && next.classList.contains("field-error")) {
        next.remove();
    }
}

/**
 * Debounce: ritarda l'esecuzione di fn di `wait` ms.
 * Utilizzato per non inondare il server di richieste AJAX.
 */
function debounce(fn, wait) {
    let timer;
    return function (...args) {
        clearTimeout(timer);
        timer = setTimeout(() => fn.apply(this, args), wait);
    };
}

/* ═══════════════════════════════════════════════════════════════════════════
   2.  REGEX E REGOLE DI VALIDAZIONE
═══════════════════════════════════════════════════════════════════════════ */

const REGEX = {
    /** Solo lettere (incluse lettere accentate italiane), spazi e trattini */
    nome:      /^[A-Za-zÀ-ÖØ-öø-ÿ\s'-]{2,50}$/,

    /**
     * Email: standard RFC 5321 semplificato
     * Es. validi:  mario.rossi@email.com  |  user+tag@sub.domain.it
     */
    email:     /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/,

    /**
     * Password: min 8 caratteri, almeno una lettera e almeno un numero.
     * Max 64 caratteri (safe per bcrypt).
     */
    password:  /^(?=.*[A-Za-z])(?=.*\d).{8,64}$/,

    /** Via/Piazza + numero civico nel campo testo (es. "Via Roma") */
    indirizzo: /^[A-Za-zÀ-ÖØ-öø-ÿ0-9\s.,'/-]{3,100}$/,

    /** Numero civico: intero positivo, max 4 cifre, con eventuale lettera finale (es. 12A) */
    nCivico:   /^[1-9]\d{0,3}[A-Za-z]?$/,

    /** CAP italiano: esattamente 5 cifre */
    cap:       /^\d{5}$/,

    /** Città: lettere, spazi, apostrofi, trattini */
    citta:     /^[A-Za-zÀ-ÖØ-öø-ÿ\s'-]{2,50}$/,
};

const MSG = {
    required:  "Campo obbligatorio.",
    nome:      "Inserisci un nome valido (2–50 lettere).",
    cognome:   "Inserisci un cognome valido (2–50 lettere).",
    email:     "Inserisci un indirizzo email valido.",
    emailUsed: "Questa email è già registrata.",
    emailAvail:"Email disponibile ✓",
    password:  "La password deve contenere almeno 8 caratteri, una lettera e un numero.",
    password2: "Le due password non coincidono.",
    indirizzo: "Inserisci un indirizzo valido (min 3 caratteri).",
    nCivico:   "Inserisci un numero civico valido (es. 5, 12A).",
    cap:       "Il CAP deve essere composto da 5 cifre.",
    citta:     "Inserisci una città valida (2–50 lettere).",
};

/* ═══════════════════════════════════════════════════════════════════════════
   3.  VALIDATORI PER SINGOLO CAMPO
═══════════════════════════════════════════════════════════════════════════ */

/**
 * Valida un singolo campo e mostra/nasconde il messaggio di errore.
 * @returns {boolean} true se il campo è valido
 */
function validateField(input) {
    const id    = input.id;
    const value = input.value.trim();

    // 1. Campo obbligatorio
    if (value === "") {
        showError(input, MSG.required);
        return false;
    }

    // 2. Regola specifica per id
    switch (id) {
        case "nome":
            if (!REGEX.nome.test(value)) { showError(input, MSG.nome);    return false; }
            break;
        case "cognome":
            if (!REGEX.nome.test(value)) { showError(input, MSG.cognome); return false; }
            break;
        case "email":
            if (!REGEX.email.test(value)) { showError(input, MSG.email);  return false; }
            break;
        case "password":
            if (!REGEX.password.test(value)) { showError(input, MSG.password); return false; }
            break;
        case "password2":
        case "pwConferma": {
            // Cerca il campo password corrispondente
            const form = input.closest("form");
            const pw   = form ? form.querySelector("#password, #pwNuova") : null;
            if (pw && input.value !== pw.value) {
                showError(input, MSG.password2);
                return false;
            }
            break;
        }
        case "indirizzo":
            if (!REGEX.indirizzo.test(value)) { showError(input, MSG.indirizzo); return false; }
            break;
        case "nCivico":
            if (!REGEX.nCivico.test(value)) { showError(input, MSG.nCivico);   return false; }
            break;
        case "cap":
            if (!REGEX.cap.test(value)) { showError(input, MSG.cap);           return false; }
            break;
        case "citta":
            if (!REGEX.citta.test(value)) { showError(input, MSG.citta);       return false; }
            break;
    }

    clearError(input);
    return true;
}

/* ═══════════════════════════════════════════════════════════════════════════
   4.  VERIFICA EMAIL AJAX  (solo nel form di registrazione)
═══════════════════════════════════════════════════════════════════════════ */

/**
 * Chiamata Fetch all'endpoint /check-email-ajax.
 * Visualizza un feedback visivo direttamente sotto il campo email.
 *
 * Risposta JSON attesa dal server:
 *   { "disponibile": true  }   → email libera
 *   { "disponibile": false }   → email già usata
 */
async function checkEmailAvailability(emailInput) {
    const value = emailInput.value.trim();

    // Non interrogare il server se il formato è già errato
    if (!REGEX.email.test(value)) return;

    // Rimuovi il feedback precedente prima della nuova richiesta
    clearError(emailInput);

    // Elemento di feedback sotto il campo
    let feedback = emailInput.parentElement.querySelector(".email-feedback");
    if (!feedback) {
        feedback = document.createElement("span");
        feedback.className = "email-feedback";
        emailInput.insertAdjacentElement("afterend", feedback);
    }
    feedback.textContent = "Verifica in corso…";
    feedback.className   = "email-feedback email-checking";

    try {
        // Costruisce l'URL relativo al context path del progetto
        const ctx = document.querySelector("meta[name='contextPath']")?.content ?? "";
        const url = `${ctx}/check-email-ajax?email=${encodeURIComponent(value)}`;

        const response = await fetch(url, {
            method:  "GET",
            headers: { "Accept": "application/json" },
        });

        if (!response.ok) throw new Error("Risposta HTTP non OK");

        const data = await response.json();

        if (data.disponibile) {
            feedback.textContent = MSG.emailAvail;
            feedback.className   = "email-feedback email-ok";
            emailInput.classList.remove("input-error");
        } else {
            feedback.textContent = MSG.emailUsed;
            feedback.className   = "email-feedback email-error";
            emailInput.classList.add("input-error");
        }
    } catch (err) {
        // Errore di rete: non bloccare il form, solo rimuovi il feedback
        console.warn("check-email-ajax: errore di rete", err);
        feedback.remove();
    }
}

/* ═══════════════════════════════════════════════════════════════════════════
   5.  FORM REGISTRAZIONE
═══════════════════════════════════════════════════════════════════════════ */

function initRegistrazioneForm() {
    const form = document.getElementById("registrazioneForm");
    if (!form) return;

    const campi = form.querySelectorAll("input[id]");

    // Validazione on-blur campo per campo
    campi.forEach(input => {
        input.addEventListener("blur", () => validateField(input));
        input.addEventListener("input", () => {
            if (input.classList.contains("input-error")) validateField(input);
        });
    });

    // Verifica AJAX email con debounce di 500 ms
    const emailInput = form.querySelector("#email");
    if (emailInput) {
        const debouncedCheck = debounce(checkEmailAvailability, 500);
        emailInput.addEventListener("input", () => debouncedCheck(emailInput));
        emailInput.addEventListener("blur",  () => checkEmailAvailability(emailInput));
    }

    // Submit: valida tutti i campi prima di inviare
    form.addEventListener("submit", function (e) {
        let formValido = true;

        campi.forEach(input => {
            // I campi password vuoti nell'area riservata sono opzionali: li saltiamo
            if (input.id === "pwNuova" || input.id === "pwConferma") return;
            if (!validateField(input)) formValido = false;
        });

        // Blocca il submit se l'email è già segnata come usata
        if (emailInput) {
            const feedback = emailInput.parentElement.querySelector(".email-feedback");
            if (feedback && feedback.classList.contains("email-error")) {
                formValido = false;
            }
        }

        if (!formValido) {
            e.preventDefault();
            // Scroll al primo errore
            const primoErrore = form.querySelector(".input-error");
            if (primoErrore) primoErrore.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    });
}

/* ═══════════════════════════════════════════════════════════════════════════
   6.  FORM LOGIN
═══════════════════════════════════════════════════════════════════════════ */

function initLoginForm() {
    const form = document.getElementById("loginForm");
    if (!form) return;

    const emailInput    = form.querySelector("#email");
    const passwordInput = form.querySelector("#password");

    if (emailInput)    emailInput.addEventListener("blur",  () => validateField(emailInput));
    if (passwordInput) passwordInput.addEventListener("blur", () => {
        // Nel login la password NON viene validata con la regex complessità
        // (l'utente potrebbe avere una password vecchia non conforme):
        // ci limitiamo a verificare che non sia vuota.
        if (passwordInput.value.trim() === "") {
            showError(passwordInput, MSG.required);
        } else {
            clearError(passwordInput);
        }
    });

    form.addEventListener("submit", function (e) {
        let ok = true;
        if (emailInput && !validateField(emailInput)) ok = false;
        if (passwordInput && passwordInput.value.trim() === "") {
            showError(passwordInput, MSG.required);
            ok = false;
        }
        if (!ok) e.preventDefault();
    });
}

/* ═══════════════════════════════════════════════════════════════════════════
   7.  FORM MODIFICA PROFILO  (area riservata)
═══════════════════════════════════════════════════════════════════════════ */

function initEditForm() {
    const form = document.getElementById("editForm");
    if (!form) return;

    const campi = form.querySelectorAll("input[id]");

    campi.forEach(input => {
        input.addEventListener("blur", () => {
            // Campi password vuoti = lasciare invariata → non validare
            if ((input.id === "pwNuova" || input.id === "pwConferma") &&
                input.value.trim() === "") {
                clearError(input);
                return;
            }
            validateField(input);
        });
    });

    form.addEventListener("submit", function (e) {
        let formValido = true;

        campi.forEach(input => {
            // Password vuote → skip
            if ((input.id === "pwNuova" || input.id === "pwConferma") &&
                input.value.trim() === "") {
                clearError(input);
                return;
            }
            if (!validateField(input)) formValido = false;
        });

        // Se si vuole cambiare password, entrambi i campi devono essere compilati
        const pwNuova    = form.querySelector("#pwNuova");
        const pwConferma = form.querySelector("#pwConferma");
        if (pwNuova && pwConferma) {
            const pn = pwNuova.value.trim();
            const pc = pwConferma.value.trim();
            if ((pn !== "" || pc !== "")) {
                // Uno solo compilato → errore
                if (pn === "") { showError(pwNuova,    MSG.required); formValido = false; }
                if (pc === "") { showError(pwConferma, MSG.required); formValido = false; }
                // Entrambi compilati: regex + match
                if (pn !== "" && !REGEX.password.test(pn)) {
                    showError(pwNuova, MSG.password);
                    formValido = false;
                }
                if (pn !== "" && pc !== "" && pn !== pc) {
                    showError(pwConferma, MSG.password2);
                    formValido = false;
                }
            }
        }

        if (!formValido) {
            e.preventDefault();
            const primoErrore = form.querySelector(".input-error");
            if (primoErrore) primoErrore.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    });
}

/* ═══════════════════════════════════════════════════════════════════════════
   8.  INIT GLOBALE
═══════════════════════════════════════════════════════════════════════════ */

document.addEventListener("DOMContentLoaded", function () {
    initRegistrazioneForm();
    initLoginForm();
    initEditForm();
});
