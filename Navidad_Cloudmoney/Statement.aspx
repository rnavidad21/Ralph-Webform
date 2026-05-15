<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Statement.aspx.cs" Inherits="Navidad_Cloudmoney.Statement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CloudMoney | Statement</title>
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
        <li><a href="Statement.aspx" class="nav-active">Statement</a></li>
        <li><a href="DW_History.aspx">DW History</a></li>
        <li><a href="Transaction.aspx">Transactions</a></li>
        <li><a href="Change_Password.aspx">Password</a></li>
        <li><a href="Logout.aspx" class="logout-btn">Log out</a></li>
      </ul>
    </nav>
  </header>

  <main class="container">
    <div class="greeting">Account overview</div>
    <h1 class="page-title">My Statement of Account</h1>

    <%-- ── Filter card ── --%>
    <div class="filter-card">
      <div class="filter-row">

        <%-- From date field --%>
        <div class="filter-field">
          <label class="field-label">From</label>
          <asp:TextBox ID="txtFromDate" runat="server"
            CssClass="field-input date-input"
            TextMode="Date" />
          <asp:RequiredFieldValidator ID="rfvFrom" runat="server"
            ControlToValidate="txtFromDate"
            ErrorMessage="From date required"
            CssClass="val-msg" Display="Dynamic" />
        </div>

        <%-- To date field --%>
        <div class="filter-field">
          <label class="field-label">To</label>
          <asp:TextBox ID="txtToDate" runat="server"
            CssClass="field-input date-input"
            TextMode="Date" />
          <asp:RequiredFieldValidator ID="rfvTo" runat="server"
            ControlToValidate="txtToDate"
            ForeColor="LightCoral"
            ErrorMessage="To date required"
            CssClass="val-msg"
            Display="Dynamic" />
          <asp:CustomValidator ID="cvDates" runat="server"
            OnServerValidate="cvDates_ServerValidate"
            Display="Dynamic"
            ForeColor="LightCoral"
            ErrorMessage="Invalid Date Range!"
            CssClass="val-msg" />
        </div>

        <div class="filter-actions">
          <asp:Button ID="btnList" runat="server"
            Text="List"
            CssClass="list-btn"
            OnClick="btnList_Click" />
          <asp:Button ID="btnDashboard" runat="server"
            Text="View Dashboard"
            CssClass="dashboard-btn"
            OnClick="btnDashboard_Click"
            CausesValidation="false" />
        </div>

      </div>
      <asp:Label ID="lblMessage" runat="server" CssClass="result-msg" />
    </div>

    <%-- ── Statement GridView ── --%>
    <asp:Panel ID="pnlTable" runat="server" Visible="false">
      <div class="table-wrap">
        <div class="viewStatement">
          <asp:GridView ID="gvStatement" runat="server"
            AutoGenerateColumns="false"
            CssClass="stmt-table"
            HeaderStyle-CssClass="stmt-header"
            RowStyle-CssClass="row-even"
            AlternatingRowStyle-CssClass="row-odd"
            GridLines="None">
            <Columns>
              <asp:BoundField DataField="SeqNo"         HeaderText="Seq. #"        ItemStyle-CssClass="seq-cell" />
              <asp:BoundField DataField="Type"          HeaderText="Type"          ItemStyle-CssClass="type-cell" />
              <asp:BoundField DataField="Date"          HeaderText="Date"          DataFormatString="{0:MM/dd/yyyy HH:mm tt}" ItemStyle-CssClass="date-cell" />
              <asp:BoundField DataField="Debit"         HeaderText="Debit"         DataFormatString="₱{0:N2}"  ItemStyle-CssClass="amount-cell debit-cell"   NullDisplayText="" />
              <asp:BoundField DataField="Credit"        HeaderText="Credit"        DataFormatString="₱{0:N2}"  ItemStyle-CssClass="amount-cell credit-cell"  NullDisplayText="" />
              <asp:BoundField DataField="Balance"       HeaderText="Balance"       DataFormatString="₱{0:N2}"  ItemStyle-CssClass="amount-cell balance-cell" NullDisplayText="" />
              <asp:BoundField DataField="SentTo"        HeaderText="Sent To"       ItemStyle-CssClass="ref-cell" NullDisplayText="" />
              <asp:BoundField DataField="Received_From" HeaderText="Received From" ItemStyle-CssClass="ref-cell" NullDisplayText="" />
            </Columns>
          </asp:GridView>
        </div>
      </div>

      <%-- Summary strip --%>
      <div class="summary-strip">
        <div class="summary-item">
          <span class="summary-label">Total Debits</span>
          <asp:Label ID="lblTotalDebit" runat="server" CssClass="summary-value debit-val" />
        </div>
        <div class="summary-item">
          <span class="summary-label">Total Credits</span>
          <asp:Label ID="lblTotalCredit" runat="server" CssClass="summary-value credit-val" />
        </div>
        <div class="summary-item">
          <span class="summary-label">Closing Balance</span>
          <asp:Label ID="lblClosingBalance" runat="server" CssClass="summary-value balance-val" />
        </div>
      </div>
    </asp:Panel>

    <%-- Empty state --%>
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
      <div class="empty-state">
        <div class="empty-icon">⟳</div>
        <div class="empty-text">No transactions found for the selected period.</div>
      </div>
    </asp:Panel>

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
      margin-bottom: 28px;
    }

    /* ── Filter card ── */
    .filter-card {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      padding: 24px 26px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      margin-bottom: 20px;
    }

    .filter-row {
      display: flex;
      align-items: flex-start;
      gap: 20px;
      flex-wrap: wrap;
    }

    .filter-field {
      display: flex;
      flex-direction: column;
      gap: 7px;
    }

    .field-label {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.55);
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }

    .field-input {
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

    .date-input {
      width: 180px;
      color-scheme: dark;
    }

    .field-input:focus { border-color: rgba(22,216,214,0.6); }

    .filter-actions {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-top: calc(14px + 7px);
      height: 42px;
    }

    .list-btn {
      font-family: 'Syne', sans-serif;
      font-size: 13px;
      font-weight: 600;
      background: #16d8d6;
      border: none;
      border-radius: 8px;
      padding: 11px 28px;
      color: #003c5a;
      cursor: pointer;
      letter-spacing: 0.02em;
      transition: opacity 0.2s, transform 0.1s;
    }

    .list-btn:hover  { opacity: 0.88; }
    .list-btn:active { transform: scale(0.99); }

    .dashboard-btn {
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      font-weight: 400;
      background: transparent;
      border: none;
      color: #16d8d6;
      cursor: pointer;
      letter-spacing: 0.06em;
      border-bottom: 0.5px solid rgba(22,216,214,0.4);
      padding: 0 0 1px 0;
      transition: opacity 0.2s;
    }

    .dashboard-btn:hover { opacity: 0.7; }

    .val-msg {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: #ff9999;
      letter-spacing: 0.03em;
      min-height: 0;
    }

    .result-msg {
      display: block;
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      font-weight: 600;
      margin-top: 12px;
      letter-spacing: 0.04em;
    }

    /* ── Table wrapper ── */
    .table-wrap {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      overflow-x: auto;
      margin-bottom: 16px;
    }

    .viewStatement {
      width: 100%;
      min-width: 720px;
    }

    .stmt-table {
      width: 100%;
      border-collapse: collapse;
    }

    .stmt-table th {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      font-weight: 500;
      color: #16d8d6;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      padding: 14px 16px;
      text-align: left;
      white-space: nowrap;
      border-bottom: 0.5px solid rgba(22, 216, 214, 0.35);
      background: transparent;
    }

    .stmt-table td {
      font-family: 'DM Mono', monospace;
      font-size: 12px;
      color: rgba(255,255,255,0.75);
      padding: 13px 16px;
      vertical-align: middle;
      border-bottom: 0.5px solid rgba(255,255,255,0.06);
    }

    .stmt-table tr:last-child td { border-bottom: none; }
    .stmt-table tr:hover td { background: rgba(22, 216, 214, 0.06); }

    .row-even td { background: transparent; }
    .row-odd  td { background: rgba(0,0,0,0.08); }

    .seq-cell {
      color: rgba(255,255,255,0.35) !important;
      font-size: 11px !important;
      width: 48px;
    }

    .type-cell {
      font-weight: 500;
      color: #e0f7fa !important;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      font-size: 11px !important;
    }

    .date-cell {
      white-space: nowrap;
      color: rgba(255,255,255,0.6) !important;
    }

    .amount-cell {
      text-align: right;
      white-space: nowrap;
    }

    .debit-cell   { color: #ff9999 !important; }
    .credit-cell  { color: #7af0a0 !important; }
    .balance-cell { color: #16d8d6 !important; font-weight: 500; }

    .ref-cell {
      font-size: 11px !important;
      color: rgba(255,255,255,0.5) !important;
      letter-spacing: 0.04em;
    }

    /* ── Summary strip ── */
    .summary-strip {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      padding: 18px 26px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      display: flex;
      gap: 40px;
      flex-wrap: wrap;
    }

    .summary-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .summary-label {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      color: rgba(255,255,255,0.45);
      text-transform: uppercase;
      letter-spacing: 0.1em;
    }

    .summary-value {
      font-family: 'DM Mono', monospace;
      font-size: 18px;
      font-weight: 500;
    }

    .debit-val   { color: #ff9999; }
    .credit-val  { color: #7af0a0; }
    .balance-val { color: #16d8d6; }

    /* ── Empty state ── */
    .empty-state {
      background: rgba(0, 66, 91, 0.62);
      border: 0.5px solid rgba(22, 216, 214, 0.2);
      border-radius: 14px;
      padding: 60px 26px;
      backdrop-filter: blur(10px);
      text-align: center;
    }

    .empty-icon {
      font-size: 36px;
      color: rgba(22,216,214,0.4);
      margin-bottom: 14px;
    }

    .empty-text {
      font-family: 'DM Mono', monospace;
      font-size: 13px;
      color: rgba(255,255,255,0.4);
      letter-spacing: 0.04em;
    }
    </style>

</body>
</html>