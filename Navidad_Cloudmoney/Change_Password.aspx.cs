using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Change_Password : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = Session["Username"].ToString();
            string currentPassword = txtPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Step 1: Verify current password
            SqlCommand cmdCheck = new SqlCommand(
                "SELECT Password FROM Users WHERE Username=@Username", conn);
            cmdCheck.Parameters.AddWithValue("@Username", username);

            object result = cmdCheck.ExecuteScalar();
            cmdCheck.Dispose();

            if (result == null)
            {
                conn.Close();
                conn.Dispose();
                lblFeedback_Password_Message.ForeColor = System.Drawing.Color.LightCoral;
                lblFeedback_Password_Message.Text = "User not found!";
                return;
            }

            if (!result.ToString().Equals(currentPassword))
            {
                conn.Close();
                conn.Dispose();
                lblFeedback_Password_Message.ForeColor = System.Drawing.Color.LightCoral;
                lblFeedback_Password_Message.Text = "Current password is incorrect!";
                return;
            }

            // Step 2: Update password
            SqlCommand cmdUpdate = new SqlCommand(
                "UPDATE Users SET Password=@NewPassword WHERE Username=@Username", conn);
            cmdUpdate.Parameters.AddWithValue("@NewPassword", newPassword);
            cmdUpdate.Parameters.AddWithValue("@Username", username);
            cmdUpdate.ExecuteNonQuery();
            cmdUpdate.Dispose();

            conn.Close();
            conn.Dispose();

            lblFeedback_Password_Message.ForeColor = System.Drawing.Color.YellowGreen;
            lblFeedback_Password_Message.Text = "Password changed successfully!";
        }
    }
}