using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Navidad_Cloudmoney
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private readonly string _conn =
            ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        private void LoadDashboard()
        {
            string username = Session["Username"].ToString();

            using (var con = new SqlConnection(_conn))
            {
                con.Open();

                // Load user info
                using (var cmd = new SqlCommand(
                    @"SELECT FullName, Balance, TotalSent, AccountNo, DateRegistered,
                             ProfilePicture, ProfilePictureType, Gender
                      FROM   Users
                      WHERE  Username = @u", con))
                {
                    cmd.Parameters.AddWithValue("@u", username);
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string fullName = dr["FullName"].ToString();

                            // Split name and take first + last word only
                            string[] nameParts = fullName.Split(' ');
                            string shortName = nameParts.Length >= 2
                                ? nameParts[0] + " " + nameParts[nameParts.Length - 1]
                                : fullName;

                            lblName.Text = shortName;   // Welcome back → "Ralph Navidad"
                            lblName2.Text = fullName;   // Account Details → "Ralph B. Navidad"

                            lblBalance.Text = "₱" + Convert.ToDecimal(dr["Balance"]).ToString("N2");
                            lblSentAmount.Text = "₱" + Convert.ToDecimal(dr["TotalSent"]).ToString("N2");
                            lblAccountNo.Text = dr["AccountNo"].ToString();
                            lblDateRegistered.Text = Convert.ToDateTime(dr["DateRegistered"]).ToString("MMMM dd, yyyy");

                            // Profile picture
                            byte[] picBytes = dr["ProfilePicture"] as byte[];
                            string picType = dr["ProfilePictureType"] as string;

                            if (picBytes != null && picBytes.Length > 0 && !string.IsNullOrEmpty(picType))
                            {
                                string mime = picType.TrimStart('.').ToLower() == "png"
                                            ? "image/png" : "image/jpeg";
                                imgProfile.ImageUrl =
                                    $"data:{mime};base64,{Convert.ToBase64String(picBytes)}";
                            }
                            else
                            {
                                string gender = dr["Gender"] as string ?? "";
                                bool isFemale = gender.Trim().ToLower() == "female";
                                imgProfile.ImageUrl = isFemale
                                    ? ResolveUrl("~/images/default_profile_female.png")
                                    : ResolveUrl("~/images/default_profile_male.png");
                            }
                        }
                    }
                }

                // Load notifications
                LoadNotifications(con, username);
            }
        }

        private void LoadNotifications(SqlConnection con, string username)
        {
            var notifications = new List<object>();

            using (var cmd = new SqlCommand(
                @"SELECT TOP 10 
                      s.Type, s.Debit, s.Credit, s.Date,
                      s.SentTo, s.Received_From,
                      receiver.FullName AS ReceiverFullName,
                      sender.FullName   AS SenderFullName
                  FROM   [Statement] s
                  LEFT JOIN Users receiver ON RTRIM(receiver.AccountNo) = RTRIM(s.SentTo)
                  LEFT JOIN Users sender   ON RTRIM(sender.Username)    = RTRIM(s.Received_From)
                  WHERE  RTRIM(s.Username) = RTRIM(@u)
                  ORDER  BY s.Date DESC", con))
            {
                cmd.Parameters.AddWithValue("@u", username);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        string type = dr["Type"].ToString().Trim();
                        decimal debit = dr["Debit"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["Debit"]);
                        decimal credit = dr["Credit"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["Credit"]);
                        DateTime date = Convert.ToDateTime(dr["Date"]);
                        string message = "";

                        if (type == "Send")
                        {
                            string name = dr["ReceiverFullName"] == DBNull.Value || string.IsNullOrEmpty(dr["ReceiverFullName"].ToString())
                                        ? dr["SentTo"].ToString().Trim()
                                        : dr["ReceiverFullName"].ToString().Trim();
                            message = $"You sent ₱{debit:N2} to {name}.";
                        }
                        else if (type == "Receive")
                        {
                            string name = dr["SenderFullName"] == DBNull.Value || string.IsNullOrEmpty(dr["SenderFullName"].ToString())
                                        ? dr["Received_From"].ToString().Trim()
                                        : dr["SenderFullName"].ToString().Trim();
                            message = $"You received ₱{credit:N2} from {name}.";
                        }
                        else if (type == "Deposit")
                        {
                            message = $"You deposited ₱{credit:N2} to your account.";
                        }
                        else if (type == "Withdraw")
                        {
                            message = $"You withdrew ₱{debit:N2} from your account.";
                        }

                        if (!string.IsNullOrEmpty(message))
                        {
                            bool isNew = (DateTime.Now - date).TotalHours < 24;
                            notifications.Add(new
                            {
                                Message = message,
                                IsNew = isNew,
                                TimeAgo = GetTimeAgo(date)
                            });
                        }
                    }
                }
            }

            if (notifications.Count > 0)
            {
                rptNotifications.DataSource = notifications;
                rptNotifications.DataBind();
                rptNotifications.Visible = true;
                lblNotifications.Visible = false;
            }
            else
            {
                rptNotifications.Visible = false;
                lblNotifications.Visible = true;
                lblNotifications.Text = "No notifications yet.";
            }
        }

        private string GetTimeAgo(DateTime dt)
        {
            TimeSpan diff = DateTime.Now - dt;
            if (diff.TotalMinutes < 1) return "Just now";
            if (diff.TotalMinutes < 60) return $"{(int)diff.TotalMinutes}m ago";
            if (diff.TotalHours < 24) return $"{(int)diff.TotalHours}h ago";
            if (diff.TotalDays < 7) return $"{(int)diff.TotalDays}d ago";
            return dt.ToString("MMM dd, yyyy");
        }

        // Profile picture upload
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile) return;

            string ext = System.IO.Path.GetExtension(fileUpload.FileName).ToLower();
            if (ext != ".png" && ext != ".jpg" && ext != ".jpeg") return;

            byte[] fileBytes = fileUpload.FileBytes;
            string username = Session["Username"].ToString();

            using (var con = new SqlConnection(_conn))
            using (var cmd = new SqlCommand(
                "UPDATE Users SET ProfilePicture = @pic, ProfilePictureType = @type WHERE Username = @u", con))
            {
                cmd.Parameters.AddWithValue("@pic", fileBytes);
                cmd.Parameters.AddWithValue("@type", ext);
                cmd.Parameters.AddWithValue("@u", username);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadDashboard();
        }
    }
}