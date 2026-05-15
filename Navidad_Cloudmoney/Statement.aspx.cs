using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Statement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                txtFromDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)
                                       .ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        protected void cvDates_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            DateTime fromDate, toDate;
            if (DateTime.TryParse(txtFromDate.Text, out fromDate) &&
                DateTime.TryParse(txtToDate.Text, out toDate))
            {
                args.IsValid = (fromDate <= toDate &&
                                fromDate <= DateTime.Now &&
                                toDate <= DateTime.Now);
            }
            else
            {
                args.IsValid = false;
            }
        }

        protected void btnList_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            pnlTable.Visible = false;
            pnlEmpty.Visible = false;

            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate) ||
                !DateTime.TryParse(txtToDate.Text, out toDate))
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Please enter valid From and To dates.";
                return;
            }

            if (fromDate > toDate)
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "From date cannot be later than To date.";
                return;
            }

            if (toDate > DateTime.Now)
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "To date cannot be in the future.";
                return;
            }

            toDate = toDate.Date.AddDays(1).AddSeconds(-1);

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            string username = Session["Username"].ToString();
            string accountNo = GetAccountNo(username, connStr);

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            SqlCommand cmd = new SqlCommand(@"
                SELECT
                    Type,
                    Date,
                    Debit,
                    Credit,
                    Balance,
                    SentTo,
                    Received_From
                FROM Statement
                WHERE Username = @Username
                  AND Date BETWEEN @FromDate AND @ToDate
                ORDER BY Date ASC", conn);

            cmd.Parameters.AddWithValue("@Username", username);
            cmd.Parameters.AddWithValue("@FromDate", fromDate);
            cmd.Parameters.AddWithValue("@ToDate", toDate);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                return;
            }

            // Add SeqNo column for row numbering
            dt.Columns.Add("SeqNo", typeof(int));

            decimal totalDebit = 0, totalCredit = 0, closingBal = 0;

            // Loop through all rows using for loop
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dt.Rows[i]["SeqNo"] = i + 1;

                string type = dt.Rows[i]["Type"].ToString().ToLower();

                // Adjust SentTo / Received_From based on transaction Type
                if (type == "send" || type == "sent")
                {
                    dt.Rows[i]["SentTo"] = accountNo;
                    dt.Rows[i]["Received_From"] = DBNull.Value;
                }
                else if (type == "receive" || type == "received")
                {
                    dt.Rows[i]["SentTo"] = DBNull.Value;
                    dt.Rows[i]["Received_From"] = accountNo;
                }
                else if (type == "deposit" || type == "withdraw")
                {
                    // Both null — it's obviously the account owner
                    dt.Rows[i]["SentTo"] = DBNull.Value;
                    dt.Rows[i]["Received_From"] = DBNull.Value;
                }

                // Zero-out blanks so NullDisplayText shows empty
                if (dt.Rows[i]["Debit"] != DBNull.Value && Convert.ToDecimal(dt.Rows[i]["Debit"]) == 0)
                    dt.Rows[i]["Debit"] = DBNull.Value;
                if (dt.Rows[i]["Credit"] != DBNull.Value && Convert.ToDecimal(dt.Rows[i]["Credit"]) == 0)
                    dt.Rows[i]["Credit"] = DBNull.Value;

                // Accumulate summary totals
                if (dt.Rows[i]["Debit"] != DBNull.Value)
                    totalDebit += Convert.ToDecimal(dt.Rows[i]["Debit"]);
                if (dt.Rows[i]["Credit"] != DBNull.Value)
                    totalCredit += Convert.ToDecimal(dt.Rows[i]["Credit"]);
                if (dt.Rows[i]["Balance"] != DBNull.Value)
                    closingBal = Convert.ToDecimal(dt.Rows[i]["Balance"]);
            }

            gvStatement.DataSource = dt;
            gvStatement.DataBind();

            // Display summary totals
            lblTotalDebit.Text = "₱" + totalDebit.ToString("N2");
            lblTotalCredit.Text = "₱" + totalCredit.ToString("N2");
            lblClosingBalance.Text = "₱" + closingBal.ToString("N2");

            pnlTable.Visible = true;
        }

        // Fetch the logged-in user's account number
        private string GetAccountNo(string username, string connStr)
        {
            string accountNo = username;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            SqlCommand cmd = new SqlCommand(@"
                SELECT AccountNo 
                FROM Users 
                WHERE Username = @Username", conn);

            cmd.Parameters.AddWithValue("@Username", username);

            object result = cmd.ExecuteScalar();

            if (result != null && result != DBNull.Value)
                accountNo = result.ToString().Trim();

            conn.Close();

            return accountNo;
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}