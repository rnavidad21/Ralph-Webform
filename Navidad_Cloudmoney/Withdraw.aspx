<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Withdraw.aspx.cs" Inherits="Navidad_Cloudmoney.Withdraw" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Withdraw</title>
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
        <li><a href="Withdraw.aspx" class="nav-active">Withdraw</a></li>
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
    <div class="greeting">Account management</div>
    <h1 class="page-title">Withdraw Funds</h1>

    <div class="layout">

      <%-- ── Left: Balance + Rules ── --%>
      <div class="left-panel">

        <div class="balance-card">
          <div class="balance-label">Current Balance</div>
          <div class="balance-amount">
            ₱<asp:Label ID="lblBalance" runat="server" CssClass="balance-value" Text="0.00" />
          </div>
          <div class="balance-sub">Available funds</div>
        </div>

        <div class="info-card">
          <div class="info-title">Withdrawal Rules</div>
          <ul class="info-list">
            <li>
              <span class="info-icon">↑</span>
              <span>Minimum withdrawal: <strong>₱100</strong></span>
            </li>
            <li>
              <span class="info-icon">↓</span>
              <span>Maximum withdrawal: <strong>₱2,000</strong></span>
            </li>
            <li>
              <span class="info-icon">÷</span>
              <span>Must be divisible by <strong>100</strong></span>
            </li>
            <li>
              <span class="info-icon">#</span>
              <span>Must be a <strong>whole number</strong></span>
            </li>
            <li>
              <span class="info-icon">⊙</span>
              <span>Cannot exceed your <strong>current balance</strong></span>
            </li>
          </ul>
        </div>

      </div>

      <%-- ── Right: Withdraw form ── --%>
      <div class="right-panel">
        <div class="action-card">

          <div class="card-heading">Enter Withdrawal Amount</div>

          <div class="input-group">
            <label class="field-label">Amount to Withdraw</label>
            <div class="input-wrap">
              <span class="currency-prefix">₱</span>
              <asp:TextBox ID="txtWAmount" runat="server"
                CssClass="field-input"
                placeholder="e.g. 500" />
            </div>

            <asp:RequiredFieldValidator ID="rfvWithdraw_Amount" runat="server"
              ControlToValidate="txtWAmount"
              ErrorMessage="Withdrawal amount is required."
              CssClass="val-msg" Display="Dynamic" />

            <asp:RangeValidator ID="rvWithdraw_Amount" runat="server"
              ControlToValidate="txtWAmount"
              MinimumValue="100" 
              MaximumValue="2000"
              Type="Double"
              ErrorMessage="Amount must be between ₱100 and ₱2,000."
              CssClass="val-msg" 
              Display="Dynamic" />

            <asp:RegularExpressionValidator ID="revWithdraw_Amount" runat="server"
              ControlToValidate="txtWAmount"
              ValidationExpression="^\d+$"
              ErrorMessage="Amount must be a whole number."
              CssClass="val-msg" 
              Display="Dynamic" />

            <asp:CustomValidator ID="cvDivisible" runat="server"
              ControlToValidate="txtWAmount"
              OnServerValidate="cvDivisible_ServerValidate"
              ErrorMessage="Amount must be divisible by 100."
              CssClass="val-msg" 
              Display="Dynamic" />

            <asp:CustomValidator ID="cvFunds" runat="server"
              ControlToValidate="txtWAmount"
              OnServerValidate="cvFunds_ServerValidate"
              ErrorMessage="Insufficient funds!"
              CssClass="val-msg" 
              Display="Dynamic" />
          </div>

          <asp:Button ID="btnWithdraw" runat="server"
            Text="Withdraw Now"
            CssClass="action-btn"
            OnClick="btnWithdraw_Click" />

          <asp:Label ID="lblWithdraw_Message" runat="server" CssClass="result-msg" />

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

    .balance-card {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.3);
      border-radius: 14px;
      padding: 28px 26px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    .balance-label {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.45);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 10px;
    }

    .balance-amount {
      font-family: 'DM Mono', monospace;
      font-size: 36px;
      font-weight: 500;
      color: #16d8d6;
      letter-spacing: -0.02em;
      line-height: 1;
      margin-bottom: 8px;
    }

    .balance-sub {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.3);
      letter-spacing: 0.06em;
    }

    .info-card {
      background: rgba(0, 66, 91, 0.45);
      border: 0.5px solid rgba(22, 216, 214, 0.15);
      border-radius: 14px;
      padding: 22px 24px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    .info-title {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.4);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 14px;
    }

    .info-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .info-list li {
      display: flex;
      align-items: center;
      gap: 10px;
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      color: rgba(255,255,255,0.5);
    }

    .info-list li strong {
      color: rgba(255,255,255,0.75);
      font-weight: 500;
    }

    .info-icon {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(255,153,153,0.12);
      border: 0.5px solid rgba(255,153,153,0.25);
      color: #ff9999;
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
      gap: 22px;
    }

    .card-heading {
      font-size: 16px;
      font-weight: 600;
      color: #fff;
      letter-spacing: -0.01em;
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

    .currency-prefix {
      font-family: 'DM Mono', monospace;
      font-size: 15px;
      color: rgba(255,153,153,0.8);
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
      font-size: 15px;
      color: #e0f7fa;
      padding: 0 16px 0 6px;
      height: 100%;
    }

    .field-input::placeholder {
      color: rgba(255,255,255,0.25);
    }

    .field-input::-webkit-outer-spin-button,
    .field-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
    .field-input[type=number] { -moz-appearance: textfield; }

    /* ── Action button — red tint for withdraw ── */
    .action-btn {
      font-family: 'Syne', sans-serif;
      font-size: 14px;
      font-weight: 600;
      background: #ff9999;
      border: none;
      border-radius: 8px;
      padding: 0;
      height: 50px;
      width: 100%;
      color: #3c0000;
      cursor: pointer;
      letter-spacing: 0.02em;
      transition: opacity 0.2s, transform 0.1s;
    }

    .action-btn:hover  { opacity: 0.88; }
    .action-btn:active { transform: scale(0.99); }

    /* ── Validation & result messages ── */
    .val-msg {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: #ff9999;
      letter-spacing: 0.03em;
    }

    .result-msg {
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      letter-spacing: 0.03em;
      min-height: 18px;
      display: block;
    }
    </style>

</body>
</html>