using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Generate 10-digit numeric AccountNo using Ticks + randomness
            long ticks = DateTime.Now.Ticks;
            int randomPart = new Random((int)(ticks & 0xFFFFFFFF)).Next(0, 9999);
            string generatedAccountNo = ((ticks % 900000 + 100000) * 10000 + randomPart)
                                            .ToString("D10").Substring(0, 10);

            // Extract middle initial (first letter, uppercase + ".")
            string middleInitial = string.IsNullOrWhiteSpace(txtMiddleName.Text)
                ? ""
                : txtMiddleName.Text.Trim().Substring(0, 1).ToUpper() + ".";

            // Build FullName with middle initial
            string fullName = txtFirstName.Text.Trim() + " " +
                              (string.IsNullOrEmpty(middleInitial) ? "" : middleInitial + " ") +
                              txtLastName.Text.Trim();

            string query = @"INSERT INTO Users
                (AccountNo, FullName, DOB, Gender, Email, Phone, Address,
                 Username, Password, AccountType, InitialDeposit, DateRegistered, Balance, TotalSent)
                VALUES
                (@AccountNo, @FullName, @DOB, @Gender, @Email, @Phone, @Address,
                 @Username, @Password, @AccountType, @InitialDeposit, @DateRegistered, @Balance, @TotalSent)";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@AccountNo", generatedAccountNo);
            cmd.Parameters.AddWithValue("@FullName", fullName);
            cmd.Parameters.AddWithValue("@DOB", txtDOB.Text.Trim());
            cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
            cmd.Parameters.AddWithValue("@AccountType", ddlAccountType.SelectedValue);
            cmd.Parameters.AddWithValue("@InitialDeposit", Convert.ToDecimal(txtInitialDeposit.Text.Trim()));
            cmd.Parameters.AddWithValue("@DateRegistered", DateTime.Now);
            cmd.Parameters.AddWithValue("@Balance", Convert.ToDecimal(txtInitialDeposit.Text.Trim()));
            cmd.Parameters.AddWithValue("@TotalSent", 0);

            int rows = cmd.ExecuteNonQuery();

            cmd.Dispose();
            conn.Close();
            conn.Dispose();

            if (rows > 0)
            {
                lblMessage_Success.ForeColor = System.Drawing.Color.YellowGreen;
                lblMessage_Success.Text = "Registration successful! Your Account No is: " + generatedAccountNo;
            }
            else
            {
                lblMessage_Failed_Registration.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Failed_Registration.Text = "Registration failed. Please try again.";
            }
        }
    }
}
