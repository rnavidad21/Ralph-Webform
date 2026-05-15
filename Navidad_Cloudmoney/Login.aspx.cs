using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            string query = "SELECT COUNT(*) FROM Users WHERE Username=@Username AND Password=@Password";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());

            int count = (int)cmd.ExecuteScalar();

            cmd.Dispose();
            conn.Close();
            conn.Dispose();

            if (count > 0)
            {
                Session["Username"] = txtUsername.Text.Trim();
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                lblMessage_Failed_Login.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_Failed_Login.Text = "Wrong Username or Password!";
            }
        }
    }
}