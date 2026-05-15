using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Transaction : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
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
            if (!Page.IsValid)
            {
                lblMessage.Text = "Please fix the errors above.";
                pnlTable.Visible = false;
                pnlEmpty.Visible = false;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string accountNo = GetAccountNo(conn);

                // ✅ JOIN with Users table to get SenderAccountNo dynamically
                string query = @"SELECT t.DateTrans AS DateSent,
                                        t.Amount,
                                        t.RecipientAccountNo,
                                        t.SenderUsername,
                                        u.AccountNo AS SenderAccountNo
                                 FROM Transactions t
                                 INNER JOIN Users u ON t.SenderUsername = u.Username
                                 WHERE (t.SenderUsername = @Username OR t.RecipientAccountNo = @AccountNo)
                                 AND t.DateTrans BETWEEN @FromDate AND @ToDate";

                if (ddlType.SelectedValue == "Sent")
                    query += " AND t.SenderUsername = @Username";
                else if (ddlType.SelectedValue == "Received")
                    query += " AND t.RecipientAccountNo = @AccountNo";

                query += " ORDER BY t.DateTrans ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
                    cmd.Parameters.AddWithValue("@AccountNo", accountNo);
                    cmd.Parameters.AddWithValue("@FromDate", txtFromDate.Text + " 00:00:00");
                    cmd.Parameters.AddWithValue("@ToDate", txtToDate.Text + " 23:59:59");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    lblMessage.Text = "";

                    if (dt.Rows.Count > 0)
                    {
                        // Add SeqNo column for ordered numbering
                        dt.Columns.Add("SeqNo", typeof(int));
                        for (int i = 0; i < dt.Rows.Count; i++)
                            dt.Rows[i]["SeqNo"] = i + 1;

                        // Add SentTo and Received_From columns for display
                        dt.Columns.Add("SentTo", typeof(string));
                        dt.Columns.Add("Received_From", typeof(string));

                        foreach (DataRow row in dt.Rows)
                        {
                            string senderUser = row["SenderUsername"].ToString();
                            string recipientAcc = row["RecipientAccountNo"].ToString();
                            string senderAcc = row["SenderAccountNo"].ToString(); // ✅ pulled from Users table

                            if (senderUser == Session["Username"].ToString())
                            {
                                // Sent transaction
                                row["SentTo"] = recipientAcc;
                                row["Received_From"] = DBNull.Value;
                            }
                            else
                            {
                                // Received transaction → show sender’s account number
                                row["SentTo"] = DBNull.Value;
                                row["Received_From"] = senderAcc;
                            }
                        }

                        gvTransactions.DataSource = dt;
                        gvTransactions.DataBind();
                        pnlTable.Visible = true;
                        pnlEmpty.Visible = false;
                    }
                    else
                    {
                        pnlTable.Visible = false;
                        pnlEmpty.Visible = true;
                    }
                }
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        private string GetAccountNo(SqlConnection conn)
        {
            string query = "SELECT AccountNo FROM Users WHERE Username = @Username";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "";
            }
        }
    }
}

