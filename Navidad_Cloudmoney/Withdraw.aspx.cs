using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Navidad_Cloudmoney
{
    public partial class Withdraw : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadWithdrawBalance();
        }

        private void LoadWithdrawBalance()
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

        protected void cvDivisible_ServerValidate(object source, ServerValidateEventArgs e)
        {
            int amount = int.Parse(e.Value); // gets what the user typed

            if (amount % 100 == 0)
            {
                e.IsValid = true;  // it passed — no error shown
            }
            else
            {
                e.IsValid = false; // it failed — show the error message
            }
        }

        protected void cvFunds_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Get what the user typed and convert it to a number
            decimal amount = decimal.Parse(args.Value);

            // Get the database connection string from Web.config
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            // Open the database connection
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            SqlCommand cmd = new SqlCommand("SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());

            object result = cmd.ExecuteScalar();

            if (result != null && result != DBNull.Value)
                args.IsValid = (Convert.ToDecimal(result) >= amount);
            else
                args.IsValid = false;

            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        protected void btnWithdraw_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                lblWithdraw_Message.ForeColor = System.Drawing.Color.LightCoral;
                lblWithdraw_Message.Text = "Withdrawal failed. Please check the Withdrawal Rules!";
                return;
            }

            decimal amount = Convert.ToDecimal(txtWAmount.Text.Trim());
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            string username = Session["Username"].ToString();
            DateTime now = DateTime.Now;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Deduct from balance
            SqlCommand cmdDeduct = new SqlCommand(
                "UPDATE Users SET Balance = Balance - @Amount WHERE Username=@Username", conn);
            cmdDeduct.Parameters.AddWithValue("@Amount", amount);
            cmdDeduct.Parameters.AddWithValue("@Username", username);
            cmdDeduct.ExecuteNonQuery();
            cmdDeduct.Dispose();

            // Get new balance
            decimal newBalance = 0;
            SqlCommand cmdBal = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmdBal.Parameters.AddWithValue("@Username", username);
            object bal = cmdBal.ExecuteScalar();
            if (bal != null && bal != DBNull.Value)
                newBalance = Convert.ToDecimal(bal);
            cmdBal.Dispose();

            // Log into DW_History — use SqlDbType.DateTime to avoid type mismatch
            SqlCommand cmdHistory = new SqlCommand(
                "INSERT INTO DW_History (Username, Type, Amount, Date) VALUES (@Username, 'Withdraw', @Amount, @Date)",
                conn);
            cmdHistory.Parameters.AddWithValue("@Username", username);
            cmdHistory.Parameters.AddWithValue("@Amount", amount);
            cmdHistory.Parameters.Add("@Date", SqlDbType.DateTime).Value = now;
            cmdHistory.ExecuteNonQuery();
            cmdHistory.Dispose();

            // Log into Statement — same fix
            SqlCommand cmdStmt = new SqlCommand(
                @"INSERT INTO Statement (Username, Type, Date, Debit, Credit, Balance, SentTo, Received_From)
                  VALUES (@Username, 'Withdraw', @Date, @Amount, 0, @NewBalance, NULL, NULL)",
                conn);
            cmdStmt.Parameters.AddWithValue("@Username", username);
            cmdStmt.Parameters.Add("@Date", SqlDbType.DateTime).Value = now;
            cmdStmt.Parameters.AddWithValue("@Amount", amount);
            cmdStmt.Parameters.AddWithValue("@NewBalance", newBalance);
            cmdStmt.ExecuteNonQuery();
            cmdStmt.Dispose();

            conn.Close();
            conn.Dispose();

            LoadWithdrawBalance();
            lblWithdraw_Message.ForeColor = System.Drawing.Color.YellowGreen;
            lblWithdraw_Message.Text = "Withdrawal successful! New balance: ₱" + newBalance.ToString("N2");
        }
    }
}