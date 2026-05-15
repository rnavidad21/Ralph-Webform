<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Navidad_Cloudmoney.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600&family=DM+Mono:wght@400;500&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
</head>
<body>
<form id="form1" runat="server">

  <main class="page-wrap">

    <!-- ── Left: Ad carousel ── -->
    <div class="ad-panel">
      <div class="ad-track">

        <!-- ✅ THIS is the belt that slides horizontally -->
        <div class="ad-belt" id="adBelt">
          <div class="ad-slide">
            <img src="../images/new_ad1.png" alt="CloudMoney Ad 1" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/cloudmoney_advertisement.png" alt="CloudMoney Ad 2" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/Cloudmoney_anime_ads.png" alt="CloudMoney Ad 3" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/ad_mascot.png" alt="CloudMoney Ad 4" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/Black_card_ads.png" alt="CloudMoney Ad 5" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/gold_card_ads.png" alt="CloudMoney Ad 6" class="ad-img" />
          </div>
          <div class="ad-slide">
            <img src="../images/silver_card_ads.png" alt="CloudMoney Ad 7" class="ad-img" />
          </div>
        </div>
        <!-- ✅ End of belt -->

      </div>

      <!-- Dot indicators -->
      <div class="ad-dots" id="adDots">
        <span class="ad-dot active" onclick="goToSlide(0)"></span>
        <span class="ad-dot" onclick="goToSlide(1)"></span>
        <span class="ad-dot" onclick="goToSlide(2)"></span>
        <span class="ad-dot" onclick="goToSlide(3)"></span>
        <span class="ad-dot" onclick="goToSlide(4)"></span>
        <span class="ad-dot" onclick="goToSlide(5)"></span>
        <span class="ad-dot" onclick="goToSlide(6)"></span>
      </div>
    </div>

    <!-- ── Right: Login card ── -->
    <div class="right-panel">
      <div class="login-card">

        <!-- Card header -->
        <div class="card-header">
          <div class="header-top">
            <div class="header-logo">
              <img src="../images/nav_logo.png" alt="CloudMoney" class="header-logo-img" />
              <span class="header-wordmark">Cloud<span class="header-money">Money</span></span>
            </div>
          </div>
          <div class="header-divider"></div>
          <div class="header-bottom">
            <div class="header-greeting">Welcome back</div>
            <div class="header-sub">Sign in to your account to continue</div>
          </div>
          <div class="orb orb-1"></div>
          <div class="orb orb-2"></div>
          <div class="orb orb-3"></div>
        </div>

        <!-- Card body -->
        <div class="card-body">

          <div class="input-group">
            <label class="field-label">
              <i class="bi bi-person-fill label-icon"></i>
              Username
            </label>
            <div class="input-wrap">
              <asp:TextBox ID="txtUsername" runat="server"
                CssClass="field-input"
                placeholder="Enter your username" />
            </div>
            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
              ControlToValidate="txtUsername"
              ErrorMessage="Username is required."
              CssClass="val-msg" Display="Dynamic" />
          </div>

          <div class="input-group">
            <label class="field-label">
              <i class="bi bi-lock-fill label-icon"></i>
              Password
            </label>
            <div class="input-wrap">
              <asp:TextBox ID="txtPassword" runat="server"
                TextMode="Password"
                CssClass="field-input"
                placeholder="Enter your password" />
              <span class="toggle-pw" onclick="togglePassword()" title="Show / hide">
                <i class="bi bi-eye-fill" id="eyeIcon"></i>
              </span>
            </div>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
              ControlToValidate="txtPassword"
              ErrorMessage="Password is required."
              CssClass="val-msg" Display="Dynamic" />
          </div>

          <asp:Label ID="lblMessage_Failed_Login" runat="server" CssClass="error-msg" />

          <asp:Button ID="btnLogin" runat="server"
            Text="Sign In"
            CssClass="login-btn"
            OnClick="btnLogin_Click" />

          <div class="divider">
            <span class="divider-line"></span>
            <span class="divider-text">no account yet?</span>
            <span class="divider-line"></span>
          </div>

          <a href="Register.aspx" class="register-link">
            <i class="bi bi-person-plus-fill"></i>
            Create a new account
          </a>

        </div>
      </div>
    </div>

  </main>
</form>

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: 'Syne', sans-serif;
  min-height: 100vh;
  background: repeating-linear-gradient(
    90deg,
    #16d8d6,
    #0093cd 20%,
    #06749f 40%,
    #055879 60%,
    #16d8d6 80%
  );
  background-size: 300% 300%;
  animation: gradientMotion 15s linear infinite;
}

@keyframes gradientMotion {
  0%   { background-position: 0% 50%; }
  50%  { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.page-wrap {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr 520px;
}

.ad-panel {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 44px;
  position: relative;
  overflow: hidden;
  background: rgba(0, 20, 38, 0.28);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  border-right: 0.5px solid rgba(22, 216, 214, 0.18);
}

/* Outer clipping container — overflow: hidden clips the belt */
.ad-track {
  width: 100%;
  max-width: 700px;
  height: 420px;
  border-radius: 8px;
  border: 0.5px solid rgba(22, 216, 214, 0.25);
  box-shadow: 0 12px 50px rgba(0, 0, 0, 0.3);
  background: #001f33;
  overflow: hidden;   /* ← clips slides outside view */
  position: relative;
}

/* Belt: all slides in a single horizontal row */
.ad-belt {
  display: flex;
  width: 100%;
  height: 100%;
  transform: translateX(0%);
  transition: transform 0.75s cubic-bezier(0.45, 0, 0.2, 1);
  will-change: transform;
}

/* Each slide takes exactly the full track width */
.ad-slide {
  flex: 0 0 100%;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ad-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
  border-radius: 8px;
}

.ad-dots {
  display: flex;
  gap: 8px;
  margin-top: 20px;
}

.ad-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.25);
  border: 0.5px solid rgba(255, 255, 255, 0.3);
  cursor: pointer;
  transition: background 0.3s, width 0.3s, border-radius 0.3s;
}

.ad-dot.active {
  background: #16d8d6;
  border-color: #16d8d6;
  width: 24px;
  border-radius: 4px;
}

.right-panel {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px 52px;
  background: rgba(0, 15, 30, 0.22);
  backdrop-filter: blur(6px);
  -webkit-backdrop-filter: blur(6px);
}

.login-card {
  width: 100%;
  max-width: 420px;
  border-radius: 22px;
  overflow: hidden;
  border: 0.5px solid rgba(22, 216, 214, 0.3);
  animation: cardIn 0.55s ease both;
}

@keyframes cardIn {
  from { opacity: 0; transform: translateY(18px); }
  to   { opacity: 1; transform: translateY(0); }
}

.card-header {
  position: relative;
  background: rgba(0, 20, 40, 0.85);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  padding: 34px 38px 28px;
  overflow: hidden;
  border-bottom: 0.5px solid rgba(22, 216, 214, 0.22);
}

.orb {
  position: absolute;
  border-radius: 50%;
  background: rgba(22, 216, 214, 0.07);
  border: 0.5px solid rgba(22, 216, 214, 0.12);
  pointer-events: none;
}
.orb-1 { width: 130px; height: 130px; top: -40px; right: -30px; }
.orb-2 { width: 75px;  height: 75px;  bottom: -20px; right: 55px; background: rgba(249,215,87,0.05); border-color: rgba(249,215,87,0.1); }
.orb-3 { width: 48px;  height: 48px;  top: 20px; left: -14px; }

.header-top {
  position: relative;
  z-index: 1;
  margin-bottom: 18px;
  text-align: center;
}

.header-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.header-logo-img {
  height: 38px;
  width: auto;
  object-fit: contain;
}

.header-wordmark {
  font-family: 'Ubuntu', sans-serif;
  font-size: 26px;
  font-weight: 700;
  color: #fff;
  letter-spacing: -0.02em;
}

.header-money { color: #f9d757; }

.header-divider {
  height: 0.5px;
  background: rgba(22, 216, 214, 0.2);
  margin-bottom: 18px;
  position: relative;
  z-index: 1;
}

.header-bottom {
  position: relative;
  z-index: 1;
  text-align: center;
}

.header-greeting {
  font-size: 21px;
  font-weight: 600;
  color: #fff;
  letter-spacing: -0.02em;
  margin-bottom: 5px;
}

.header-sub {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.38);
  letter-spacing: 0.05em;
}

.card-body {
  background: rgba(0, 50, 75, 0.78);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  padding: 34px 38px 38px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.field-label {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255, 255, 255, 0.52);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  display: flex;
  align-items: center;
  gap: 6px;
}

.label-icon { font-size: 11px; color: #16d8d6; }

.input-wrap {
  display: flex;
  align-items: center;
  background: rgba(0, 75, 108, 0.75);
  border: 0.5px solid rgba(255, 255, 255, 0.16);
  border-radius: 10px;
  height: 50px;
  transition: border-color 0.2s, box-shadow 0.2s;
  overflow: hidden;
}

.input-wrap:focus-within {
  border-color: rgba(22, 216, 214, 0.6);
  box-shadow: 0 0 0 3px rgba(22, 216, 214, 0.07);
}

.field-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  font-family: 'DM Mono', monospace;
  font-size: 13px;
  color: #e0f7fa;
  padding: 0 16px;
  height: 100%;
  width: 100%;
}

.field-input::placeholder { color: rgba(255, 255, 255, 0.18); }

.toggle-pw {
  padding: 0 16px;
  color: rgba(255, 255, 255, 0.28);
  cursor: pointer;
  font-size: 14px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  transition: color 0.2s;
}

.toggle-pw:hover { color: #16d8d6; }

.val-msg {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: #ff9999;
  letter-spacing: 0.03em;
}

.error-msg {
  display: block;
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  font-weight: 600;
  color: #ff9999;
  text-align: center;
  letter-spacing: 0.03em;
  min-height: 14px;
}

.login-btn {
  font-family: 'Syne', sans-serif;
  font-size: 15px;
  font-weight: 600;
  background: #16d8d6;
  border: none;
  border-radius: 10px;
  height: 52px;
  width: 100%;
  color: #003c5a;
  cursor: pointer;
  letter-spacing: 0.03em;
  transition: opacity 0.2s, transform 0.1s;
  margin-top: 2px;
}

.login-btn:hover  { opacity: 0.88; }
.login-btn:active { transform: scale(0.99); }

.divider {
  display: flex;
  align-items: center;
  gap: 12px;
}

.divider-line {
  flex: 1;
  height: 0.5px;
  background: rgba(255, 255, 255, 0.1);
}

.divider-text {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255, 255, 255, 0.25);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  white-space: nowrap;
}

.register-link {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-family: 'DM Mono', monospace;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.42);
  text-decoration: none;
  letter-spacing: 0.04em;
  padding: 14px;
  border: 0.5px solid rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  transition: border-color 0.2s, color 0.2s, background 0.2s;
}

.register-link i { font-size: 13px; color: #16d8d6; }

.register-link:hover {
  border-color: rgba(22, 216, 214, 0.38);
  color: rgba(255, 255, 255, 0.7);
  background: rgba(22, 216, 214, 0.05);
}
</style>

<script type="text/javascript">
    var current = 0;
    var totalSlides = 7;
    var belt, dots;
    var isAnimating = false;

    function goToSlide(next) {
        if (next === current || isAnimating) return;
        isAnimating = true;

        current = next;

        // Slide belt left/right to show the target slide
        belt.style.transform = 'translateX(-' + (current * 100) + '%)';

        // Update active dot
        dots.forEach(function (d) { d.classList.remove('active'); });
        dots[current].classList.add('active');

        setTimeout(function () { isAnimating = false; }, 750);
    }

    function nextSlide() {
        goToSlide((current + 1) % totalSlides);
    }

    function startCarousel() {
        belt = document.getElementById('adBelt');
        dots = document.querySelectorAll('.ad-dot');

        belt.style.transform = 'translateX(0%)';
        dots[0].classList.add('active');

        setInterval(nextSlide, 3500);
    }

    document.addEventListener('DOMContentLoaded', startCarousel);

    function togglePassword() {
        var tb = document.getElementById('<%= txtPassword.ClientID %>');
        var ico = document.getElementById('eyeIcon');
        if (!tb) return;
        if (tb.type === 'password') {
            tb.type = 'text';
            ico.className = 'bi bi-eye-slash-fill';
        } else {
            tb.type = 'password';
            ico.className = 'bi bi-eye-fill';
        }
    }
</script>

</body>
</html>