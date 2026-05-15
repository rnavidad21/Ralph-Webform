using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class DW_History : System.Web.UI.Page
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
                // Only check that fromDate is not later than toDate
                // Do NOT block today's date — toDate can be today
                args.IsValid = (fromDate <= toDate);
            }
            else
            {
                args.IsValid = false;
            }
        }

        protected void btnList_Click(object sender, EventArgs e)
        {
            lblMessage_DW_History.Text = "";
            pnlTable.Visible = false;
            pnlEmpty.Visible = false;

            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate) ||
                !DateTime.TryParse(txtToDate.Text, out toDate))
            {
                lblMessage_DW_History.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_DW_History.Text = "Please enter valid From and To dates.";
                return;
            }

            if (fromDate > toDate)
            {
                lblMessage_DW_History.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_DW_History.Text = "From date cannot be later than To date.";
                return;
            }

            if (!Page.IsValid)
            {
                lblMessage_DW_History.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage_DW_History.Text = "Please fix the errors above.";
                return;
            }

            // Cover the full day — midnight to 23:59:59.999 of toDate
            DateTime rangeStart = fromDate.Date;
            DateTime rangeEnd = toDate.Date.AddDays(1).AddTicks(-1);

            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            string query = @"SELECT Type, Date, Amount
                             FROM DW_History
                             WHERE Username = @Username
                             AND Date >= @FromDate
                             AND Date <= @ToDate
                             AND Type IN ('Deposit', 'Withdraw')";

            if (ddlType.SelectedValue != "All")
                query += " AND Type = @Type";

            query += " ORDER BY Date ASC";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.CommandType = CommandType.Text;

            cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
            cmd.Parameters.Add("@FromDate", SqlDbType.DateTime).Value = rangeStart;
            cmd.Parameters.Add("@ToDate", SqlDbType.DateTime).Value = rangeEnd;

            if (ddlType.SelectedValue != "All")
                cmd.Parameters.AddWithValue("@Type", ddlType.SelectedValue);

            DataTable dt = new DataTable();
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            sda.Fill(dt);

            cmd.Dispose();
            conn.Close();
            conn.Dispose();

            if (dt.Rows.Count > 0)
            {
                dt.Columns.Add("SeqNo", typeof(int));
                for (int i = 0; i < dt.Rows.Count; i++)
                    dt.Rows[i]["SeqNo"] = i + 1;

                grdVwHistory.DataSource = dt;
                grdVwHistory.DataBind();
                pnlTable.Visible = true;
                pnlEmpty.Visible = false;
            }
            else
            {
                pnlTable.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}