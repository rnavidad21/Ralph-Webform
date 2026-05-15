<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Send_Cloudmoney.aspx.cs" Inherits="Navidad_Cloudmoney.Send_Cloudmoney" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Send</title>
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
        <li><a href="Send_Cloudmoney.aspx" class="nav-active">Send</a></li>
        <li><a href="Statement.aspx">Statement</a></li>
        <li><a href="DW_History.aspx">DW History</a></li>
        <li><a href="Transaction.aspx">Transactions</a></li>
        <li><a href="Change_Password.aspx">Password</a></li>
        <li><a href="Logout.aspx" class="logout-btn">Log out</a></li>
      </ul>
    </nav>
  </header>

  <main class="container">
    <div class="greeting">Transfer funds</div>
    <h1 class="page-title">Send CloudMoney</h1>

    <div class="send-layout">
      <!-- LEFT: Recipient lookup + send form -->
      <div class="left-col">

        <!-- Recipient lookup -->
        <div class="form-container">
          <div class="section-label">Recipient</div>

          <div class="field-group">
            <label class="field-label">Account number</label>
            <div class="input-row">
              <asp:TextBox ID="txtRecipient" runat="server"
                CssClass="field-input"
                placeholder="Enter 10-Digit Account No." />
              <asp:Button ID="btnCheckRecipient" runat="server"
                Text="Check"
                CssClass="check-btn"
                OnClick="btnCheckRecipient_Click"
                ValidationGroup="CheckGroup" />
            </div>
            <asp:RequiredFieldValidator ID="rfvRecipient" runat="server"
              ControlToValidate="txtRecipient"
              Display="Dynamic"
              CssClass="validator-msg"
              ValidationGroup="CheckGroup"
              ErrorMessage="Recipient account number is required!" />
          </div>
        </div>

        <!-- Recipient card — hidden until Check is clicked -->
        <asp:Panel ID="pnlRecipient" runat="server" Visible="false" style="overflow:visible;">
          <div class="recipient-card" id="recipientCard">
            <div class="recipient-pic-wrap">
              <asp:Image ID="imgRecipient" runat="server"
                CssClass="recipient-pic"
                AlternateText="Recipient" />
            </div>
            <div class="recipient-info">
              <div class="recipient-name-label">Recipient Name: </div>
              <div class="recipient-name-wrap">
                <asp:Label ID="lblRecipientName" runat="server" CssClass="recipient-name" />
              </div>
              <div class="recipient-acct-label">Account No.</div>
              <div class="recipient-acct">
                <asp:Label ID="lblRecipientAccount" runat="server" />
              </div>
            </div>
          </div>
        </asp:Panel>

        <!-- Send form -->
        <div class="form-container">
          <div class="section-label">Send details</div>

          <div class="field-group">
            <label class="field-label">Amount to send</label>
            <div class="amount-wrap">
              <span class="peso-sign">₱</span>
              <asp:TextBox ID="txtAmount" runat="server"
                CssClass="field-input amount-input"
                placeholder="100 – 2,000" />
            </div>
            <asp:RequiredFieldValidator ID="rfvAmount" runat="server"
              ControlToValidate="txtAmount"
              CssClass="validator-msg"
              Display="Dynamic"
              ErrorMessage="Amount is required."
              ValidationGroup="SendGroup" />
            <asp:RangeValidator ID="rvAmount" runat="server"
              ControlToValidate="txtAmount"
              MinimumValue="100" MaximumValue="2000"
              Type="Double"
              CssClass="validator-msg"
              Display="Dynamic"
              ErrorMessage="Amount must be between ₱100 and ₱2,000."
              ValidationGroup="SendGroup" />
            <asp:CustomValidator ID="cvDivisible" runat="server"
              ControlToValidate="txtAmount"
              OnServerValidate="cvDivisible_ServerValidate"
              ErrorMessage="Amount must be divisible by 100."
              CssClass="validator-msg"
              Display="Dynamic"
              ValidationGroup="SendGroup" />
            <asp:CustomValidator ID="cvFunds" runat="server"
              ControlToValidate="txtAmount"
              OnServerValidate="cvFunds_ServerValidate"
              CssClass="validator-msg"
              Display="Dynamic"
              ErrorMessage="Insufficient funds."
              ValidationGroup="SendGroup" />
          </div>
          <div class="field-group">
            <label class="field-label">Your password</label>
            <asp:TextBox ID="txtPassword" runat="server"
              TextMode="Password"
              CssClass="field-input"
              placeholder="Confirm your password" />
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
              ControlToValidate="txtPassword"
              CssClass="validator-msg"
              Display="Dynamic"
              ErrorMessage="Password is required."
              ValidationGroup="SendGroup" />
          </div>
          <asp:Button ID="btsend" runat="server"
            Text="Send money"
            CssClass="send-btn"
            OnClick="btsend_Click"
            ValidationGroup="SendGroup" />
          <asp:Label ID="lblMessage" runat="server" CssClass="result-msg" />
        </div>
      </div><!-- /left-col -->

      <!-- RIGHT: Balance summary -->
      <div class="right-col">
        <div class="balance-card">
          <div class="section-label">Your balance</div>
          <div class="balance-amount">
            <asp:Label ID="lblBalance" runat="server" />
          </div>
          <div class="balance-note">Available for transfer</div>
        </div>

        <div class="rules-card">
          <div class="section-label">Transfer rules</div>
          <ul class="rules-list">
            <li>Minimum send amount is <span class="rule-hl">₱100</span></li>
            <li>Maximum send amount is <span class="rule-hl">₱2,000</span></li>
            <li>Amount must be divisible by <span class="rule-hl">100</span></li>
            <li>Recipient account must exist</li>
            <li>Password confirmation required</li>
          </ul>
        </div>
      </div><!-- /right-col -->
    </div><!-- /send-layout -->
  </main>

  <%-- Hidden fields carry values across postbacks --%>
  <asp:HiddenField ID="hfRecipientGender" runat="server" ClientIDMode="Static" />
  <asp:HiddenField ID="hfRecipientAccount" runat="server" />
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

    .logo-money { color: #f9d757; }

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
      max-width: 960px;
      margin: 0 auto;
      padding: 80px 36px 60px;
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
    .send-layout {
      display: grid;
      grid-template-columns: 1fr 300px;
      gap: 16px;
      align-items: start;
    }

    /* ── Shared container card ── */
    .form-container,
    .balance-card,
    .rules-card {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      padding: 24px 26px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      margin-bottom: 16px;
    }

    .left-col  { display: flex; flex-direction: column; }
    .right-col { display: flex; flex-direction: column; }

    /* ── Section label ── */
    .section-label {
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      font-weight: 500;
      color: #16d8d6;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      border-bottom: 0.5px solid rgba(22, 216, 214, 0.35);
      padding-bottom: 10px;
      margin-bottom: 18px;
    }

    /* ── Form fields ── */
    .field-group { margin-bottom: 18px; }

    .field-label {
      display: block;
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.55);
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-bottom: 7px;
    }

    .field-input {
      width: 100%;
      background: #006389;
      border: 0.5px solid rgba(255,255,255,0.2);
      border-radius: 8px;
      padding: 11px 14px;
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: #e0f7fa;
      outline: none;
      transition: border-color 0.2s;
    }

    .field-input::placeholder { color: rgba(255,255,255,0.25); }
    .field-input:focus        { border-color: rgba(22,216,214,0.6); }

    /* ── Disabled state — visual feedback that fields are locked ── */
    .field-input:disabled,
    .send-btn:disabled {
      opacity: 0.38;
      cursor: not-allowed;
    }

    /* Account no. row */
    .input-row              { display: flex; gap: 10px; }
    .input-row .field-input { flex: 1; }

    .check-btn {
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      letter-spacing: 0.06em;
      background: rgba(22,216,214,0.18);
      border: 0.5px solid rgba(22,216,214,0.5);
      border-radius: 8px;
      color: #16d8d6;
      padding: 0 18px;
      cursor: pointer;
      white-space: nowrap;
      transition: background 0.2s;
      height: 42px;
    }

    .check-btn:hover { background: rgba(22,216,214,0.32); }

    /* Amount field with peso sign */
    .amount-wrap { position: relative; }

    .peso-sign {
      position: absolute;
      left: 13px;
      top: 50%;
      transform: translateY(-50%);
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: rgba(255,255,255,0.45);
      pointer-events: none;
    }

    .amount-input { padding-left: 28px !important; }

    /* Validators */
    .validator-msg {
      display: block;
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: #ff7f7f;
      margin-top: 5px;
      letter-spacing: 0.04em;
    }

    /* Send button */
    .send-btn {
      width: 100%;
      background: #16d8d6;
      border: none;
      border-radius: 8px;
      padding: 13px;
      font-family: 'Syne', sans-serif;
      font-size: 14px;
      font-weight: 600;
      color: #003c5a;
      cursor: pointer;
      letter-spacing: 0.02em;
      transition: opacity 0.2s, transform 0.1s;
      margin-top: 4px;
    }

    .send-btn:hover  { opacity: 0.88; }
    .send-btn:active { transform: scale(0.99); }

    /* Result message */
    .result-msg {
      display: block;
      font-family: 'DM Mono', monospace;
      font-size: 15px;
      font-weight: 700;
      margin-top: 12px;
      text-align: center;
      letter-spacing: 0.04em;
    }

    /* ── Recipient card ── */
    .recipient-card {
      display: flex;
      align-items: center;
      gap: 18px;
      border-radius: 14px;
      padding: 18px 22px;
      margin-bottom: 16px;
      border: 0.5px solid rgba(255,255,255,0.2);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    .recipient-pic-wrap {
      width: 62px;
      height: 62px;
      border-radius: 50%;
      overflow: hidden;
      border: 2px solid rgba(255,255,255,0.3);
      background: rgba(255,255,255,0.15);
      flex-shrink: 0;
    }

    .recipient-pic {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .recipient-info { flex: 1; min-width: 0; }

    .recipient-name-label,
    .recipient-acct-label {
      font-family: 'DM Mono', monospace;
      font-size: 9px;
      color: rgba(255,255,255,0.5);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 2px;
    }

    .recipient-acct-label { margin-top: 8px; }
    .recipient-name-wrap  { padding-bottom: 4px; }

    .recipient-name {
      display: block;
      font-family: 'Syne', sans-serif;
      font-size: 16px;
      font-weight: 600;
      color: #fff;
      letter-spacing: -0.01em;
      line-height: 1.5;
    }

    .recipient-acct {
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: rgba(255,255,255,0.8);
      letter-spacing: 0.05em;
    }

    /* ── Balance card ── */
    .balance-amount {
      font-size: 26px;
      font-weight: 600;
      color: #16d8d6;
      letter-spacing: -0.02em;
      margin-bottom: 6px;
    }

    .balance-note {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.4);
      letter-spacing: 0.06em;
      text-transform: uppercase;
    }

    /* ── Rules card ── */
    .rules-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .rules-list li {
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      color: rgba(255,255,255,0.6);
      padding-left: 14px;
      position: relative;
      line-height: 1.5;
    }

    .rules-list li::before {
      content: '—';
      position: absolute;
      left: 0;
      color: rgba(22,216,214,0.5);
    }

    .rule-hl {
      color: #16d8d6;
      font-weight: 500;
    }
</style>

<script type="text/javascript">
    // Colorize recipient card by gender
    window.setRecipientCardColor = function (gender) {
        var card = document.getElementById('recipientCard');
        if (!card) return;
        if (gender === 'female') {
            card.style.background = 'linear-gradient(135deg, #e623ff 0%, #bf1543 100%)';
            card.style.borderColor = 'rgba(230,35,255,0.55)';
        } else {
            card.style.background = 'linear-gradient(135deg, #2d2ec6 0%, #1590bf 100%)';
            card.style.borderColor = 'rgba(45,46,198,0.55)';
        }
    };

    document.addEventListener('DOMContentLoaded', function () {
        var genderField = document.getElementById('hfRecipientGender');
        if (genderField && genderField.value) {
            window.setRecipientCardColor(genderField.value.toLowerCase());
        }
    });
</script>
</body>
</html>