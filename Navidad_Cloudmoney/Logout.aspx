<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="Navidad_Cloudmoney.Logout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Log Out</title>
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
        <li><a href="Logout.aspx" class="logout-btn nav-active-logout">Log out</a></li>
      </ul>
    </nav>
  </header>

  <main class="container">

    <div class="farewell-wrap">

      <%-- ── Glow ring + icon ── --%>
      <div class="icon-ring">
        <div class="ring ring-outer"></div>
        <div class="ring ring-inner"></div>
        <div class="icon-core">☁</div>
      </div>

      <%-- ── Text block ── --%>
      <div class="farewell-eyebrow">Session active</div>
      <h1 class="farewell-title">Thank you for using<br />CloudMoney</h1>
      <p class="farewell-sub">
        You are about to end your current session.<br />
        Make sure you have completed all your transactions before logging out.
      </p>

      <%-- ── Session info strip ── --%>
      <div class="session-strip">
        <div class="session-item">
          <span class="session-label">Logged in as</span>
          <span class="session-value">
            <%= Session["Username"] != null ? Session["Username"].ToString() : "Guest" %>
          </span>
        </div>
        <div class="session-divider"></div>
        <div class="session-item">
          <span class="session-label">Session status</span>
          <span class="session-value status-active">● Active</span>
        </div>
      </div>

      <%-- ── Actions ── --%>
      <div class="action-row">
        <a href="Dashboard.aspx" class="stay-btn">Go back to Dashboard</a>
        <asp:Button ID="btnLogout" runat="server"
          Text="Log out now"
          CssClass="logout-confirm-btn"
          OnClick="btnLogout_Click" />
      </div>

      <div class="safety-note">
        Your activity is securely logged upon logout.
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
      display: flex;
      flex-direction: column;
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

    .nav-active-logout {
      border-color: rgba(22,216,214,0.5) !important;
      color: #16d8d6 !important;
    }

    /* ── Main ── */
    .container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 76px 36px 40px;
    }

    /* ── Farewell card ── */
    .farewell-wrap {
      background: rgba(0, 55, 80, 0.58);
      border: 0.5px solid rgba(22, 216, 214, 0.22);
      border-radius: 20px;
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      padding: 52px 60px 48px;
      max-width: 620px;
      width: 100%;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
      animation: cardIn 0.5s ease both;
    }

    @keyframes cardIn {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Glow ring icon ── */
    .icon-ring {
      position: relative;
      width: 88px;
      height: 88px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 4px;
    }

    .ring {
      position: absolute;
      border-radius: 50%;
      border: 1px solid rgba(22, 216, 214, 0.3);
      animation: pulse 2.4s ease-in-out infinite;
    }

    .ring-outer {
      width: 88px;
      height: 88px;
      animation-delay: 0s;
    }

    .ring-inner {
      width: 66px;
      height: 66px;
      border-color: rgba(22, 216, 214, 0.5);
      animation-delay: 0.4s;
    }

    @keyframes pulse {
      0%, 100% { opacity: 0.4; transform: scale(1); }
      50%       { opacity: 1;   transform: scale(1.04); }
    }

    .icon-core {
      width: 50px;
      height: 50px;
      border-radius: 14px;
      background: rgba(22, 216, 214, 0.12);
      border: 0.5px solid rgba(22, 216, 214, 0.4);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      color: #16d8d6;
      position: relative;
      z-index: 1;
    }

    /* ── Text ── */
    .farewell-eyebrow {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(22, 216, 214, 0.7);
      text-transform: uppercase;
      letter-spacing: 0.14em;
    }

    .farewell-title {
      font-size: 26px;
      font-weight: 600;
      color: #fff;
      letter-spacing: -0.02em;
      line-height: 1.25;
    }

    .farewell-sub {
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      color: rgba(255,255,255,0.42);
      line-height: 1.8;
      letter-spacing: 0.02em;
      max-width: 400px;
    }

    /* ── Session strip ── */
    .session-strip {
      display: flex;
      align-items: center;
      gap: 24px;
      background: rgba(0, 40, 60, 0.5);
      border: 0.5px solid rgba(22, 216, 214, 0.15);
      border-radius: 10px;
      padding: 14px 24px;
      width: 100%;
      justify-content: center;
    }

    .session-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 4px;
    }

    .session-label {
      font-family: 'DM Mono', monospace;
      font-size: 9px;
      color: rgba(255,255,255,0.35);
      text-transform: uppercase;
      letter-spacing: 0.1em;
    }

    .session-value {
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: rgba(255,255,255,0.8);
      font-weight: 500;
    }

    .status-active {
      color: #7af0a0 !important;
      font-size: 11px !important;
    }

    .session-divider {
      width: 0.5px;
      height: 32px;
      background: rgba(22,216,214,0.2);
    }

    /* ── Action row ── */
    .action-row {
      display: flex;
      align-items: center;
      gap: 16px;
      width: 100%;
      margin-top: 4px;
    }

    .stay-btn {
      flex: 1;
      height: 50px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      color: rgba(255,255,255,0.6);
      text-decoration: none;
      border: 0.5px solid rgba(255,255,255,0.2);
      border-radius: 8px;
      letter-spacing: 0.04em;
      transition: border-color 0.2s, color 0.2s;
    }

    .stay-btn:hover {
      border-color: rgba(22,216,214,0.5);
      color: #16d8d6;
    }

    .logout-confirm-btn {
      flex: 1;
      height: 50px;
      font-family: 'Syne', sans-serif;
      font-size: 14px;
      font-weight: 600;
      background: rgba(255, 100, 100, 0.85);
      border: none;
      border-radius: 8px;
      color: #fff;
      cursor: pointer;
      letter-spacing: 0.02em;
      transition: opacity 0.2s, transform 0.1s;
    }

    .logout-confirm-btn:hover  { opacity: 0.88; }
    .logout-confirm-btn:active { transform: scale(0.99); }

    /* ── Safety note ── */
    .safety-note {
      font-family: 'DM Mono', monospace;
      font-size: 9px;
      color: rgba(255,255,255,0.22);
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }
    </style>

</body>
</html>