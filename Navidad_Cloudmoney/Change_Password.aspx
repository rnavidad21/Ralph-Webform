<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Change_Password.aspx.cs" Inherits="Navidad_Cloudmoney.Change_Password" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Change Password</title>
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
        <li><a href="Change_Password.aspx" class="nav-active">Password</a></li>
        <li><a href="Logout.aspx" class="logout-btn">Log out</a></li>
      </ul>
    </nav>
  </header>

  <main class="container">
    <div class="greeting">Account security</div>
    <h1 class="page-title">Change Password</h1>

    <div class="layout">

      <%-- ── Left: Info panel ── --%>
      <div class="left-panel">

        <div class="info-card">
          <div class="info-icon-large">🔒</div>
          <div class="info-heading">Keep your account safe</div>
          <div class="info-body">
            Changing your password regularly helps protect your CloudMoney account from unauthorized access.
          </div>
        </div>

        <div class="tips-card">
          <div class="tips-title">Password Tips</div>
          <ul class="tips-list">
            <li>
              <span class="tip-icon">✓</span>
              <span>Use at least <strong>8 characters</strong></span>
            </li>
            <li>
              <span class="tip-icon">✓</span>
              <span>Mix <strong>letters and numbers</strong></span>
            </li>
            <li>
              <span class="tip-icon">✓</span>
              <span>Avoid using your <strong>username</strong></span>
            </li>
            <li>
              <span class="tip-icon">✓</span>
              <span>Never share your <strong>password</strong></span>
            </li>
          </ul>
        </div>

      </div>

      <%-- ── Right: Change password form ── --%>
      <div class="right-panel">
        <div class="action-card">

          <div class="card-heading">Update your password</div>

          <%-- Current Password --%>
          <div class="input-group">
            <label class="field-label">Current Password</label>
            <div class="input-wrap">
              <span class="field-icon">◉</span>
              <asp:TextBox ID="txtPassword" runat="server"
                TextMode="Password"
                CssClass="field-input"
                placeholder="Enter current password"/>
            </div>
            <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server"
              ControlToValidate="txtPassword"
              ErrorMessage="Please enter your current password."
              CssClass="val-msg"
              Display="Dynamic" />
          </div>

          <div class="divider"></div>

          <%-- New Password --%>
          <div class="input-group">
            <label class="field-label">New Password</label>
            <div class="input-wrap">
              <span class="field-icon">◈</span>
              <asp:TextBox ID="txtNewPassword" runat="server"
                TextMode="Password"
                CssClass="field-input"
                placeholder="Enter new password" />
            </div>
            <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
              ControlToValidate="txtNewPassword"
              ErrorMessage="Please enter your new password."
              CssClass="val-msg" Display="Dynamic" />
          </div>

          <%-- Confirm New Password --%>
          <div class="input-group">
            <label class="field-label">Confirm New Password</label>
            <div class="input-wrap">
              <span class="field-icon">◈</span>
              <asp:TextBox ID="txtConfirmPassword" runat="server"
                TextMode="Password"
                CssClass="field-input"
                placeholder="Re-enter new password" />
            </div>
            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
              ControlToValidate="txtConfirmPassword"
              ErrorMessage="Please confirm your new password."
              CssClass="val-msg" Display="Dynamic" />
            <asp:CompareValidator ID="cvPasswords" runat="server"
              ControlToCompare="txtNewPassword"
              ControlToValidate="txtConfirmPassword"
              ErrorMessage="New password and confirmation do not match."
              CssClass="val-msg" Display="Dynamic" />
          </div>

          <asp:Button ID="Button1" runat="server"
            Text="Change Password"
            CssClass="action-btn"
            OnClick="Button1_Click" />

          <asp:Label ID="lblFeedback_Password_Message" runat="server" CssClass="result-msg" />

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

    /* ── Logo (matches Dashboard exactly) ── */
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

    /* ── Navbar ── */
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

    .nav-active {
      color: #16d8d6 !important;
      border-bottom: 1px solid #16d8d6;
      padding-bottom: 2px;
    }

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

    /* ── Main ── */
    .container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 88px 36px 60px;
    }

    .greeting {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.5);
      letter-spacing: 0.12em;
      text-transform: uppercase;
      margin-bottom: 4px;
    }

    .page-title {
      font-size: 28px;
      font-weight: 600;
      color: #fff;
      letter-spacing: -0.02em;
      margin-bottom: 32px;
    }

    /* ── Two-column layout ── */
    .layout {
      display: grid;
      grid-template-columns: 1fr 1.6fr;
      gap: 24px;
      align-items: start;
    }

    /* ── Left panel ── */
    .left-panel {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .info-card {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.3);
      border-radius: 14px;
      padding: 30px 26px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      text-align: center;
    }

    .info-icon-large {
      font-size: 38px;
      margin-bottom: 14px;
      filter: drop-shadow(0 0 12px rgba(22,216,214,0.4));
    }

    .info-heading {
      font-size: 15px;
      font-weight: 600;
      color: #fff;
      margin-bottom: 10px;
      letter-spacing: -0.01em;
    }

    .info-body {
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      color: rgba(255,255,255,0.45);
      line-height: 1.7;
      letter-spacing: 0.02em;
    }

    .tips-card {
      background: rgba(0, 66, 91, 0.45);
      border: 0.5px solid rgba(22, 216, 214, 0.15);
      border-radius: 14px;
      padding: 22px 24px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    .tips-title {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.4);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 14px;
    }

    .tips-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .tips-list li {
      display: flex;
      align-items: center;
      gap: 10px;
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      color: rgba(255,255,255,0.5);
    }

    .tips-list li strong {
      color: rgba(255,255,255,0.75);
      font-weight: 500;
    }

    .tip-icon {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(22,216,214,0.12);
      border: 0.5px solid rgba(22,216,214,0.25);
      color: #16d8d6;
      font-size: 11px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    /* ── Right panel ── */
    .right-panel {
      display: flex;
      flex-direction: column;
    }

    .action-card {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      padding: 32px 30px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .card-heading {
      font-size: 16px;
      font-weight: 600;
      color: #fff;
      letter-spacing: -0.01em;
    }

    .divider {
      height: 0.5px;
      background: rgba(22,216,214,0.15);
      margin: 2px 0;
    }

    /* ── Input group ── */
    .input-group {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .field-label {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.55);
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }

    .input-wrap {
      display: flex;
      align-items: center;
      background: #006389;
      border: 0.5px solid rgba(255,255,255,0.2);
      border-radius: 8px;
      height: 50px;
      transition: border-color 0.2s;
    }

    .input-wrap:focus-within {
      border-color: rgba(22,216,214,0.6);
    }

    .field-icon {
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: rgba(22,216,214,0.6);
      padding: 0 4px 0 16px;
      user-select: none;
      flex-shrink: 0;
    }

    .field-input {
      flex: 1;
      background: transparent;
      border: none;
      outline: none;
      font-family: 'DM Mono', monospace;
      font-size: 14px;
      color: #e0f7fa;
      padding: 0 16px 0 8px;
      height: 100%;
      letter-spacing: 0.04em;
    }

    .field-input::placeholder {
      color: rgba(255,255,255,0.22);
      letter-spacing: 0.02em;
    }

    /* ── Action button ── */
    .action-btn {
      font-family: 'Syne', sans-serif;
      font-size: 14px;
      font-weight: 600;
      background: #16d8d6;
      border: none;
      border-radius: 8px;
      padding: 0;
      height: 50px;
      width: 100%;
      color: #003c5a;
      cursor: pointer;
      letter-spacing: 0.02em;
      transition: opacity 0.2s, transform 0.1s;
      margin-top: 4px;
    }

    .action-btn:hover  { opacity: 0.88; }
    .action-btn:active { transform: scale(0.99); }

    /* ── Validation & result messages ── */
    .val-msg {
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      font-weight: 500;
      color: #ff9999;
      letter-spacing: 0.03em;
    }

    .result-msg {
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      letter-spacing: 0.03em;
      font-weight: 600;
      min-height: 18px;
      display: block;
    }
    </style>

</body>
</html>