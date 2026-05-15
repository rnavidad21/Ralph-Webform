using System;
using System.Web;

namespace Navidad_Cloudmoney
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            HttpContext.Current.Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}