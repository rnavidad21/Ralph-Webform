using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Deposit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadDepositBalance();
        }

        private void LoadDepositBalance()
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            SqlCommand cmd = new SqlCommand("SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());

            object result = cmd.ExecuteScalar();

            lblBalance.Text = (result != null && result != DBNull.Value)
                ? Convert.ToDecimal(result).ToString("N2")
                : "0.00";

            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        protected void btDeposit_Click(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            decimal amount;
            if (!decimal.TryParse(txtDAmount.Text.Trim(), out amount))
            {
                lblMessage_Deposit.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Deposit.Text = "Invalid amount entered!";
                return;
            }

            if (amount < 100 || amount > 2000)
            {
                lblMessage_Deposit.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Deposit.Text = "Deposit must be between ₱100 and ₱2,000.";
                return;
            }

            if (amount % 100 != 0)
            {
                lblMessage_Deposit.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Deposit.Text = "Deposit must be divisible by 100.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            string username = Session["Username"].ToString();
            DateTime now = DateTime.Now;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Get current balance
            decimal currentBalance = 0;
            SqlCommand cmdBal = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmdBal.Parameters.AddWithValue("@Username", username);
            object balResult = cmdBal.ExecuteScalar();
            if (balResult != null && balResult != DBNull.Value)
                currentBalance = Convert.ToDecimal(balResult);
            cmdBal.Dispose();

            // Check balance cap
            if (currentBalance + amount > 10000)
            {
                conn.Close();
                conn.Dispose();
                lblMessage_Deposit.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Deposit.Text = "Total balance cannot exceed ₱10,000.";
                return;
            }

            decimal newBalance = currentBalance + amount;

            // Update balance
            SqlCommand cmdUpdate = new SqlCommand(
                "UPDATE Users SET Balance = Balance + @Amount WHERE Username=@Username", conn);
            cmdUpdate.Parameters.AddWithValue("@Amount", amount);
            cmdUpdate.Parameters.AddWithValue("@Username", username);
            cmdUpdate.ExecuteNonQuery();
            cmdUpdate.Dispose();

            // Log into DW_History — use SqlDbType.DateTime to avoid type mismatch
            SqlCommand cmdHistory = new SqlCommand(
                "INSERT INTO DW_History (Username, Type, Amount, Date) VALUES (@Username, 'Deposit', @Amount, @Date)",
                conn);
            cmdHistory.Parameters.AddWithValue("@Username", username);
            cmdHistory.Parameters.AddWithValue("@Amount", amount);
            cmdHistory.Parameters.Add("@Date", SqlDbType.DateTime).Value = now;
            cmdHistory.ExecuteNonQuery();
            cmdHistory.Dispose();

            // Log into Statement — same fix
            SqlCommand cmdStmt = new SqlCommand(
                @"INSERT INTO Statement (Username, Type, Date, Debit, Credit, Balance, SentTo, Received_From)
                  VALUES (@Username, 'Deposit', @Date, 0, @Amount, @NewBalance, NULL, 'Self')",
                conn);
            cmdStmt.Parameters.AddWithValue("@Username", username);
            cmdStmt.Parameters.Add("@Date", SqlDbType.DateTime).Value = now;
            cmdStmt.Parameters.AddWithValue("@Amount", amount);
            cmdStmt.Parameters.AddWithValue("@NewBalance", newBalance);
            cmdStmt.ExecuteNonQuery();
            cmdStmt.Dispose();

            conn.Close();
            conn.Dispose();

            LoadDepositBalance();
            lblMessage_Deposit.ForeColor = System.Drawing.Color.YellowGreen;
            lblMessage_Deposit.Text = "Deposit successful! New balance: ₱" + newBalance.ToString("N2");
        }
    }
}