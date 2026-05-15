<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Navidad_Cloudmoney.Dashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cloudmoney | Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600&family=DM+Mono:wght@400;500&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">

  <header>
    <a href="Dashboard.aspx" class="logo-link">
      <img src="../images/nav_logo.png" alt="CloudMoney Logo" class="logo-img" />
      <span class="logo-text">Cloud<span class="logo-money">Money</span></span>
    </a>
    <nav class="navbar">
      <ul>
        <li><a href="Deposit.aspx">Deposit</a></li>
        <li><a href="Withdraw.aspx">Withdraw</a></li>
        <li><a href="Send_Cloudmoney.aspx">Send</a></li>
        <li><a href="Statement.aspx">Statement</a></li>
        <li><a href="DW_History.aspx">DW History</a></li>
        <li><a href="Transaction.aspx">Transactions</a></li>
        <li><a href="Change_Password.aspx">Password</a></li>
        <li><a href="Logout.aspx" class="logout-btn">Log out</a></li>
      </ul>
    </nav>
  </header>

  <main class="container">

    <!-- User greeting row with profile picture -->
    <div class="greeting-row">
      <div class="profile-area">
        <div class="profile-pic-wrapper" title="Click to change photo">
          <asp:Image ID="imgProfile" runat="server" CssClass="profile-pic" AlternateText="Profile Picture" />
          <label for="fileUpload" class="profile-upload-overlay">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
              <circle cx="12" cy="13" r="4"/>
            </svg>
          </label>
          <asp:FileUpload ID="fileUpload" runat="server" 
              CssClass="hidden-upload" 
              Accept=".png,.jpg,.jpeg" 
              ClientIDMode="Static" />
          <asp:Button ID="btnUpload" runat="server" Text="" CssClass="hidden-upload" OnClick="btnUpload_Click" />
        </div>
      </div>
      <div class="greeting-text">
        <div class="greeting">Welcome back</div>
        <h1 class="account-name"><asp:Label ID="lblName" runat="server" /></h1>
      </div>
    </div>

    <!-- Unified dashboard container: Overview + Account Details -->
    <div class="dashboard-container">
      <div class="section-label">Overview</div>
      <div class="stats-row">
        <div class="stat-card accent">
          <div class="stat-label">Current balance</div>
          <asp:Label ID="lblBalance" runat="server" CssClass="stat-value" />
        </div>
        <div class="stat-card">
          <div class="stat-label">Total sent</div>
          <asp:Label ID="lblSentAmount" runat="server" CssClass="stat-value" />
        </div>
        <div class="stat-card">
          <div class="stat-label">Account no.</div>
          <asp:Label ID="lblAccountNo" runat="server" CssClass="stat-value mono-sm" />
        </div>
      </div>

      <div class="section-label">Account details</div>
      <div class="info-row">
        <div class="info-card">
          <div class="info-label">Full Name</div>
          <asp:Label ID="lblName2" runat="server" CssClass="info-value" />
        </div>
        <div class="info-card">
          <div class="info-label">Date Registered</div>
          <asp:Label ID="lblDateRegistered" runat="server" CssClass="info-value" />
        </div>
      </div>
    </div><!-- /dashboard-container -->

    <!-- Notifications — separate container -->
    <div class="notif-container">
      <div class="section-label">Notifications</div>
      <div class="notif-list">
        <asp:Repeater ID="rptNotifications" runat="server">
          <ItemTemplate>
            <div class="notif-card <%# Eval("IsNew") != null && (bool)Eval("IsNew") ? "notif-new" : "notif-read" %>">
              <div class="notif-icon-wrap">
                <div class="notif-dot"></div>
              </div>
              <div class="notif-body">
                <div class="notif-meta">
                  <span class="notif-tag"><%# Eval("IsNew") != null && (bool)Eval("IsNew") ? "New" : "Read" %></span>
                  <span class="notif-time"><%# Eval("TimeAgo") %></span>
                </div>
                <div class="notif-message"><%# Eval("Message") %></div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
        <asp:Label ID="lblNotifications" runat="server" CssClass="notif-fallback" />
      </div>
    </div><!-- /notif-container -->

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

/* ── Header ── */
header {
  position: fixed;
  top: 0; left: 0;
  width: 100%;
  height: 56px;
  background: rgba(0, 60, 90, 0.55);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 0.5px solid rgba(22, 216, 214, 0.25);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 36px;
  z-index: 100;
}

.logo-link {
  display: flex;
  align-items: center;
  text-decoration: none;
  flex-shrink: 0;
}

.logo-img {
  height: 40px;
  width: auto;
  display: block;
  object-fit: contain;
  transition: opacity 0.2s;
}

.logo-img:hover { opacity: 0.82; }

.logo-text {
  font-family: 'Ubuntu', sans-serif;
  font-size: 28px;
  font-weight: 700;
  color: #fff;
  letter-spacing: -0.02em;
  margin-left: 10px;
}

.logo-money {
  color: #f9d757;
}

.navbar ul {
  list-style: none;
  display: flex;
  align-items: center;
  gap: 22px;
}

.navbar ul li a {
  color: rgba(255,255,255,0.6);
  text-decoration: none;
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  letter-spacing: 0.04em;
  transition: color 0.2s;
}

.navbar ul li a:hover { color: #16d8d6; }

.logout-btn {
  border: 0.5px solid rgba(255,255,255,0.25) !important;
  padding: 5px 12px !important;
  border-radius: 4px;
  color: rgba(255,255,255,0.5) !important;
}

.logout-btn:hover {
  border-color: rgba(22,216,214,0.5) !important;
  color: #16d8d6 !important;
}

/* ── Main layout ── */
.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 80px 36px 60px;
}

/* ── Greeting row ── */
.greeting-row {
  display: flex;
  align-items: center;
  gap: 22px;
  margin-bottom: 28px;
}

.greeting-text { flex: 1; }

.greeting {
  font-family: 'DM Mono', monospace;
  font-size: 14px;
  color: rgba(255,255,255,0.5);
  letter-spacing: 0.12em;
  text-transform: uppercase;
  margin-bottom: 4px;
}

.account-name {
  font-size: 36px;
  font-weight: 600;
  color: #fff;
  letter-spacing: -0.02em;
}

/* ── Profile picture ── */
.profile-area {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.profile-pic-wrapper {
  position: relative;
  width: 110px;
  height: 110px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid rgba(22,216,214,0.55);
  background: #006389;
  cursor: pointer;
  flex-shrink: 0;
}

.profile-pic {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.profile-upload-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s;
  cursor: pointer;
  color: #fff;
}

.profile-pic-wrapper:hover .profile-upload-overlay { opacity: 1; }

.hidden-upload { display: none; }

/* ── Dashboard container (Overview + Account Details) ── */
.dashboard-container {
  background: rgba(0, 66, 91, 0.62);
  border: 0.5px solid rgba(22, 216, 214, 0.2);
  border-radius: 14px;
  padding: 26px 28px 28px;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* ── Notifications container (separate) ── */
.notif-container {
  background: rgba(0, 66, 91, 0.62);
  border: 0.5px solid rgba(22, 216, 214, 0.2);
  border-radius: 14px;
  padding: 26px 28px 28px;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  margin-top: 16px;
}

/* ── Section labels ── */
.section-label {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  font-weight: 500;
  color: #16d8d6;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  border-bottom: 0.5px solid rgba(22, 216, 214, 0.35);
  padding-bottom: 10px;
  margin-bottom: 16px;
}

/* ── Stats ── */
.stats-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-bottom: 24px;
}

.stat-card {
  background: #006389;
  border: 0.5px solid rgba(255,255,255,0.18);
  border-radius: 10px;
  padding: 20px 22px;
}

.stat-card.accent {
  background: #006389;
  border-color: rgba(22, 216, 214, 0.55);
}

.stat-label {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255,255,255,0.6);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 10px;
}

.stat-value {
  display: block;
  font-size: 20px;
  font-weight: 600;
  color: #e0f7fa;
  letter-spacing: -0.02em;
}

.stat-card.accent .stat-value { color: #16d8d6; }

.mono-sm {
  font-family: 'DM Mono', monospace !important;
  font-size: 13px !important;
  letter-spacing: 0.04em;
  color: #e0f7fa !important;
}

/* ── Info row ── */
.info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-bottom: 8px;
}

.info-card {
  background: #006389;
  border: 0.5px solid rgba(255,255,255,0.18);
  border-radius: 10px;
  padding: 16px 22px;
}

.info-label {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255,255,255,0.55);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 6px;
}

.info-value {
  display: block;
  font-size: 13px;
  font-weight: 500;
  color: #e0f7fa;
  font-family: 'DM Mono', monospace;
}

/* ── Notifications ── */
.notif-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notif-card {
  background: #006389;
  border-radius: 10px;
  padding: 14px 18px;
  display: flex;
  align-items: flex-start;
  gap: 14px;
}

.notif-card.notif-new {
  border: 0.5px solid rgba(230, 126, 34, 0.5);
  background: rgba(0, 99, 137, 0.85);
}

.notif-card.notif-read {
  border: 0.5px solid rgba(255,255,255,0.12);
  opacity: 0.75;
}

.notif-icon-wrap {
  padding-top: 4px;
  flex-shrink: 0;
}

.notif-dot {
  width: 9px; height: 9px;
  border-radius: 50%;
  background: #ffaa55;
}

.notif-card.notif-read .notif-dot {
  background: rgba(168, 230, 229, 0.35);
}

.notif-body { flex: 1; }

.notif-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 5px;
}

.notif-tag {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  font-weight: 500;
  color: #ffaa55;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.notif-card.notif-read .notif-tag {
  color: rgba(168, 230, 229, 0.5);
}

.notif-time {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  color: #a8e6e5;
  letter-spacing: 0.06em;
}

.notif-message {
  font-family: 'DM Mono', monospace;
  font-size: 12px;
  color: #e0f7fa;
  line-height: 1.6;
}

.notif-fallback {
  display: block;
  font-family: 'DM Mono', monospace;
  font-size: 12px;
  color: #e0f7fa;
  background: #006389;
  border: 0.5px solid rgba(255,170,85,0.4);
  border-radius: 10px;
  padding: 14px 18px;
}
</style>

<script type="text/javascript">
  document.addEventListener('DOMContentLoaded', function () {
    var fileInput = document.getElementById('fileUpload');
    if (fileInput) {
      fileInput.addEventListener('change', function () {
        if (this.files && this.files.length > 0) {
          var reader = new FileReader();
          reader.onload = function (e) {
            var img = document.querySelector('.profile-pic');
            if (img) img.src = e.target.result;
          };
          reader.readAsDataURL(this.files[0]);

          setTimeout(function () {
            document.getElementById('<%= btnUpload.ClientID %>').click();
          }, 300);
          }
      });
      }
  });
</script>
    
</body>
</html>