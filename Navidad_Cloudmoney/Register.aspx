<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Navidad_Cloudmoney.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Register</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700&family=DM+Mono:wght@400;500&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
  <main class="page-wrap">
    <div class="brand-panel">
      <div class="brand-inner">
        <img src="../images/Cloudmoney_logo_design.png" alt="CloudMoney Logo" class="brand-logo" />
        <p class="brand-tagline">Your digital wallet,<br />built for everyone.</p>

        <div class="brand-features">
          <div class="feature-item">
            <span class="feature-icon">⚡</span>
            <span>Instant deposits &amp; withdrawals</span>
          </div>
          <div class="feature-item">
            <span class="feature-icon">🔒</span>
            <span>Secure end-to-end transactions</span>
          </div>
          <div class="feature-item">
            <span class="feature-icon">📊</span>
            <span>Full statement &amp; history tracking</span>
          </div>
          <div class="feature-item">
            <span class="feature-icon">💸</span>
            <span>Send money in seconds</span>
          </div>
        </div>

        <div class="brand-footer">
          Already have an account?
          <a href="Login.aspx" class="brand-link">Sign in</a>
        </div>
      </div>
    </div>

    <div class="form-panel">
      <div class="form-scroll">

        <div class="form-header">
          <div class="form-eyebrow">Get started — it's free</div>
          <h2 class="form-title">Create your account</h2>
        </div>

        <div class="form-section">
          <div class="section-label">Personal Information</div>

          <div class="field-row three-col">

            <div class="input-group">
              <label class="field-label">First Name</label>
              <asp:TextBox ID="txtFirstName" runat="server" CssClass="field-input" placeholder="Juan" />
              <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                ControlToValidate="txtFirstName"
                ErrorMessage="First name required."
                CssClass="val-msg" 
                Display="Dynamic" />
              <asp:RegularExpressionValidator ID="revFirstname" runat="server"
                ControlToValidate="txtFirstName"
                ValidationExpression="^[A-Za-z]+$"
                ErrorMessage="Letters only."
                CssClass="val-msg" 
                Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Middle Name</label>
              <asp:TextBox ID="txtMiddleName" runat="server" CssClass="field-input" placeholder="Santos" />
              <asp:RegularExpressionValidator ID="revMiddleName" runat="server"
                ControlToValidate="txtMiddleName"
                ValidationExpression="^[A-Za-z]+$"
                ErrorMessage="Letters only."
                CssClass="val-msg" Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Last Name</label>
              <asp:TextBox ID="txtLastName" runat="server" CssClass="field-input" placeholder="Dela Cruz" />
              <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                ControlToValidate="txtLastName"
                ErrorMessage="Last name required."
                CssClass="val-msg" 
                Display="Dynamic" />
              <asp:RegularExpressionValidator ID="revLastName" runat="server"
                ControlToValidate="txtLastName"
                ValidationExpression="^[A-Za-z]+$"
                ErrorMessage="Letters only."
                CssClass="val-msg" 
                Display="Dynamic" />
            </div>

          </div>

          <div class="field-row two-col">

            <div class="input-group">
              <label class="field-label">Date of Birth</label>
              <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="field-input date-input" />
              <asp:RequiredFieldValidator ID="rfvDOB" runat="server"
                ControlToValidate="txtDOB"
                ErrorMessage="Date of birth required."
                CssClass="val-msg" Display="Dynamic" />
              <asp:RangeValidator ID="R" runat="server"
                ControlToValidate="txtDOB"
                MinimumValue="1900-01-01"
                MaximumValue="2008-12-31"
                Type="Date"
                ErrorMessage="Must be at least 18 years old."
                CssClass="val-msg" Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Gender</label>
              <asp:DropDownList ID="ddlGender" runat="server" CssClass="field-input select-input">
                <asp:ListItem Text="-- Select Gender --" Value="" Selected="true" Disabled="true"></asp:ListItem>
                <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
              </asp:DropDownList>
              <asp:RequiredFieldValidator ID="rfvGender" runat="server"
                ControlToValidate="ddlGender"
                InitialValue=""
                ErrorMessage="Please select your gender."
                CssClass="val-msg" Display="Dynamic" />
            </div>

          </div>
        </div>

        <div class="form-section">
          <div class="section-label">Contact Information</div>

          <div class="field-row two-col">

            <div class="input-group">
              <label class="field-label">Email</label>
              <asp:TextBox ID="txtEmail" runat="server" CssClass="field-input" placeholder="juan@email.com" />
              <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Email required."
                CssClass="val-msg" Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Phone</label>
              <asp:TextBox ID="txtPhone" runat="server" CssClass="field-input" placeholder="09XXXXXXXXX" />
              <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                ControlToValidate="txtPhone"
                ErrorMessage="Phone number required."
                CssClass="val-msg" Display="Dynamic" />
              <asp:RegularExpressionValidator ID="revPhone" runat="server"
                ControlToValidate="txtPhone"
                ValidationExpression="^\d{11}$"
                ErrorMessage="Enter an 11-digit number."
                CssClass="val-msg" Display="Dynamic" />
            </div>

          </div>

          <div class="input-group">
            <label class="field-label">Address</label>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="field-input" placeholder="123 Rizal St., Cebu City" />
            <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
              ControlToValidate="txtAddress"
              ErrorMessage="Address required."
              CssClass="val-msg" Display="Dynamic" />
            <asp:RegularExpressionValidator ID="revAddress" runat="server"
              ControlToValidate="txtAddress"
              ValidationExpression="^[a-zA-Z0-9\s,.-]+$"
              ErrorMessage="Please enter a valid address."
              CssClass="val-msg" Display="Dynamic" />
          </div>
        </div>

        <div class="form-section">
          <div class="section-label">Account Credentials</div>

          <div class="input-group">
            <label class="field-label">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="field-input" placeholder="Choose a username" />
            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
              ControlToValidate="txtUsername"
              ErrorMessage="Username required."
              CssClass="val-msg" Display="Dynamic" />
          </div>

          <div class="field-row two-col">

            <div class="input-group">
              <label class="field-label">Password</label>
              <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="field-input" placeholder="Min. 8 characters" />
              <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password required."
                CssClass="val-msg" Display="Dynamic" />
              <asp:RegularExpressionValidator ID="revPassword" runat="server"
                ControlToValidate="txtPassword"
                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                ErrorMessage="Must have upper, lower, number &amp; symbol."
                CssClass="val-msg" Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Confirm Password</label>
              <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="field-input" placeholder="Re-enter password" />
              <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                ControlToValidate="txtConfirmPassword"
                ErrorMessage="Please confirm your password."
                CssClass="val-msg" Display="Dynamic" />
              <asp:CompareValidator ID="cvConfirmPassword" runat="server"
                ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword"
                ErrorMessage="Passwords do not match."
                CssClass="val-msg" Display="Dynamic" />
            </div>

          </div>

          <div class="password-hint">
            Use at least 8 characters with uppercase, lowercase, a number, and a symbol (e.g. @$!%*?&amp;)
          </div>
        </div>

        <div class="form-section">
          <div class="section-label">Account Details</div>

          <div class="field-row two-col">

            <div class="input-group">
              <label class="field-label">Account Type</label>
              <asp:DropDownList ID="ddlAccountType" runat="server" CssClass="field-input select-input">
                <asp:ListItem Text="-- Select Account Type --" Value="" Selected="true" Disabled="true"></asp:ListItem>
                <asp:ListItem>Savings</asp:ListItem>
                <asp:ListItem>Checking</asp:ListItem>
              </asp:DropDownList>
              <asp:RequiredFieldValidator ID="rfvAccountType" runat="server"
                ControlToValidate="ddlAccountType"
                InitialValue=""
                ErrorMessage="Please choose account type."
                CssClass="val-msg" Display="Dynamic" />
            </div>

            <div class="input-group">
              <label class="field-label">Initial Deposit (₱)</label>
              <div class="input-wrap">
                <span class="currency-prefix">₱</span>
                <asp:TextBox ID="txtInitialDeposit" runat="server" CssClass="field-input-inner" placeholder="e.g. 500" />
              </div>
              <asp:RequiredFieldValidator ID="rfvDeposit" runat="server"
                ControlToValidate="txtInitialDeposit"
                ErrorMessage="Initial deposit required."
                CssClass="val-msg"
                Display="Dynamic" />
            </div>
              <asp:RangeValidator ID="rvIDeposit" runat="server"
                ControlToValidate="txtInitialDeposit"
                MinimumValue="100"
                MaximumValue="5000"
                ErrorMessage="Initial deposit must be between ₱1,000 and ₱5,000."
                CssClass="val-msg"
                Display="Dynamic">
              </asp:RangeValidator>
          </div>
        </div>

        <asp:Button ID="btnRegister" runat="server"
          Text="Create Account"
          CssClass="register-btn"
          OnClick="btnRegister_Click" />

        <div class="feedback-wrap">
          <asp:Label ID="lblMessage_Success" runat="server" CssClass="msg-success" />
          <asp:Label ID="lblMessage_Failed_Registration" runat="server" CssClass="msg-error" />
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

/* ── Page layout ── */
.page-wrap {
  display: grid;
  grid-template-columns: 380px 1fr;
  min-height: 100vh;
}

/* ── Left brand panel ── */
.brand-panel {
  background: rgba(0, 40, 65, 0.72);
  border-right: 0.5px solid rgba(22, 216, 214, 0.2);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px 36px;
  position: sticky;
  top: 0;
  height: 100vh;
}

.brand-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 20px;
}

.brand-logo {
  width: 190px;
  height: auto;
  object-fit: contain;
  filter: drop-shadow(0 0 18px rgba(22,216,214,0.35));
}

.brand-tagline {
  font-family: 'DM Mono', monospace;
  font-size: 13px;
  color: rgba(255,255,255,0.45);
  line-height: 1.7;
  letter-spacing: 0.02em;
}

.brand-features {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
  margin-top: 8px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  background: rgba(22,216,214,0.07);
  border: 0.5px solid rgba(22,216,214,0.15);
  border-radius: 10px;
  padding: 11px 14px;
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  color: rgba(255,255,255,0.55);
  text-align: left;
}

.feature-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.brand-footer {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  color: rgba(255,255,255,0.35);
  letter-spacing: 0.04em;
  margin-top: 8px;
}

.brand-link {
  color: #16d8d6;
  text-decoration: none;
  margin-left: 4px;
  border-bottom: 0.5px solid rgba(22,216,214,0.4);
  transition: opacity 0.2s;
}

.brand-link:hover { opacity: 0.7; }

/* ── Right form panel ── */
.form-panel {
  overflow-y: auto;
  padding: 52px 56px 60px;
  display: flex;
  flex-direction: column;
}

.form-scroll {
  max-width: 680px;
  width: 100%;
}

.form-header {
  margin-bottom: 32px;
}

.form-eyebrow {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255,255,255,0.45);
  text-transform: uppercase;
  letter-spacing: 0.14em;
  margin-bottom: 6px;
}

.form-title {
  font-size: 26px;
  font-weight: 600;
  color: #fff;
  letter-spacing: -0.02em;
}

/* ── Form sections ── */
.form-section {
  background: rgba(0, 55, 80, 0.52);
  border: 0.5px solid rgba(22, 216, 214, 0.15);
  border-radius: 14px;
  padding: 22px 22px 24px;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  margin-bottom: 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.section-label {
  font-family: 'DM Mono', monospace;
  font-size: 9px;
  color: rgba(22,216,214,0.7);
  text-transform: uppercase;
  letter-spacing: 0.14em;
  padding-bottom: 10px;
  border-bottom: 0.5px solid rgba(22,216,214,0.12);
}

.field-row {
  display: grid;
  gap: 14px;
}

.two-col   { grid-template-columns: 1fr 1fr; }
.three-col { grid-template-columns: 1fr 1fr 1fr; }

.input-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255,255,255,0.5);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.field-input,
.field-input-inner {
  background: rgba(0, 80, 110, 0.7);
  border: 0.5px solid rgba(255,255,255,0.15);
  border-radius: 8px;
  padding: 0 13px;
  height: 42px;
  font-family: 'DM Mono', monospace;
  font-size: 12px;
  color: #e0f7fa;
  outline: none;
  width: 100%;
  transition: border-color 0.2s;
}

.field-input-inner {
  border: none;
  border-radius: 0 8px 8px 0;
  height: 100%;
  padding: 0 13px 0 6px;
  background: transparent;
}

.field-input:focus { border-color: rgba(22,216,214,0.6); }

.field-input::placeholder,
.field-input-inner::placeholder {
  color: rgba(255,255,255,0.2);
}

.date-input { color-scheme: dark; }

.select-input {
  cursor: pointer;
  appearance: auto;
}

.select-input option {
  background: #004f70;
  color: #e0f7fa;
}

/* ── Currency input wrap ── */
.input-wrap {
  display: flex;
  align-items: center;
  background: rgba(0, 80, 110, 0.7);
  border: 0.5px solid rgba(255,255,255,0.15);
  border-radius: 8px;
  height: 42px;
  transition: border-color 0.2s;
}

.input-wrap:focus-within { border-color: rgba(22,216,214,0.6); }

.currency-prefix {
  font-family: 'DM Mono', monospace;
  font-size: 13px;
  color: rgba(22,216,214,0.7);
  padding: 0 2px 0 13px;
  flex-shrink: 0;
  user-select: none;
}

/* ── Password hint ── */
.password-hint {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: rgba(255,255,255,0.3);
  letter-spacing: 0.03em;
  line-height: 1.6;
}

/* ── Validators ── */
.val-msg {
  font-family: 'DM Mono', monospace;
  font-size: 10px;
  color: #ff9999;
  letter-spacing: 0.03em;
}

/* ── Register button ── */
.register-btn {
  font-family: 'Syne', sans-serif;
  font-size: 14px;
  font-weight: 600;
  background: #16d8d6;
  border: none;
  border-radius: 8px;
  height: 50px;
  width: 100%;
  color: #003c5a;
  cursor: pointer;
  letter-spacing: 0.02em;
  margin-top: 8px;
  transition: opacity 0.2s, transform 0.1s;
}

.register-btn:hover  { opacity: 0.88; }
.register-btn:active { transform: scale(0.99); }

/* ── Feedback ── */
.feedback-wrap {
  margin-top: 14px;
  text-align: center;
}

.msg-success {
  font-family: 'DM Mono', monospace;
  font-size: 13px;
  font-weight: 500;
  color: #7af0a0;
  display: block;
}

.msg-error {
  font-family: 'DM Mono', monospace;
  font-size: 12px;
  color: #ff9999;
  display: block;
}

/* ── Sign in link ── */
.signin-link {
  font-family: 'DM Mono', monospace;
  font-size: 11px;
  color: rgba(255,255,255,0.35);
  text-align: center;
  margin-top: 20px;
  letter-spacing: 0.04em;
}

.signin-link a {
  color: #16d8d6;
  text-decoration: none;
  border-bottom: 0.5px solid rgba(22,216,214,0.4);
  transition: opacity 0.2s;
}

.signin-link a:hover { opacity: 0.7; }
</style>

</body>
</html>