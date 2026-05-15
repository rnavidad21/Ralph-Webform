using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Navidad_Cloudmoney
{
    public partial class Send_Cloudmoney : System.Web.UI.Page
    {
        // This runs every time the page loads
        protected void Page_Load(object sender, EventArgs e)
        {
            Form.DefaultButton = btsend.UniqueID;

            // If the user is not logged in, send them to the login page
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Show the user's current balance on the page
            LoadBalance();

            // If the page was refreshed after clicking a button
            // and a recipient was already found before
            if (IsPostBack && !string.IsNullOrEmpty(hfRecipientAccount.Value))
            {
                // Show the recipient card again
                RestoreRecipientPanel();

                // Keep the amount, password, and send button usable
                SetSendFieldsEnabled(true);
            }
            else if (!IsPostBack)
            {
                // Fresh page load — lock the amount, password, and send button
                // until the user finds a valid recipient first
                SetSendFieldsEnabled(false);
            }
        }

        // Locks or unlocks the amount box, password box, and send button
        // enabled = true  means the user can use them
        // enabled = false means the user cannot use them yet
        private void SetSendFieldsEnabled(bool enabled)
        {
            txtAmount.Enabled = enabled;
            txtPassword.Enabled = enabled;
            btsend.Enabled = enabled;
        }

        // Gets the user's balance from the database and shows it on the page
        private void LoadBalance()
        {
            // Get the database address from Web.config
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;

            // Connect to the database
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Ask the database for the balance of the logged-in user
            SqlCommand cmd = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());

            // Get the result
            object result = cmd.ExecuteScalar();

            // Show the balance on the page, or show 0.00 if no balance found
            lblBalance.Text = (result != null && result != DBNull.Value)
                ? "₱" + Convert.ToDecimal(result).ToString("N2")
                : "₱0.00";

            // Close the database connection
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        // Shows the recipient card again after the page is refreshed
        // This uses the account number saved in the hidden field
        private void RestoreRecipientPanel()
        {
            // Get the saved recipient account number
            string accNo = hfRecipientAccount.Value.Trim();

            // If no account number is saved, stop
            if (string.IsNullOrEmpty(accNo)) return;

            // Connect to the database
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Search for the recipient in the database using the account number
            SqlCommand cmd = new SqlCommand(
                "SELECT AccountNo, FullName, Gender, ProfilePicture, ProfilePictureType FROM Users WHERE AccountNo=@AccountNo",
                conn);
            cmd.Parameters.AddWithValue("@AccountNo", accNo);

            SqlDataReader reader = cmd.ExecuteReader();

            // If the recipient is found
            if (reader.Read())
            {
                // Get the recipient's gender, default to male if not found
                string gender = reader["Gender"] != DBNull.Value
                    ? reader["Gender"].ToString().ToLower() : "male";

                // Show the recipient's profile photo
                if (reader["ProfilePicture"] != DBNull.Value)
                {
                    // Convert the photo from the database into a format the page can show
                    byte[] imageBytes = (byte[])reader["ProfilePicture"];
                    string mimeType = reader["ProfilePictureType"] != DBNull.Value
                        ? reader["ProfilePictureType"].ToString().Trim() : "jpeg";
                    if (!mimeType.StartsWith("image/"))
                        mimeType = "image/" + mimeType;
                    imgRecipient.ImageUrl = "data:" + mimeType + ";base64," + Convert.ToBase64String(imageBytes);
                }
                else
                {
                    // Use a default photo based on gender if no photo is saved
                    imgRecipient.ImageUrl = ResolveUrl(
                        gender == "female"
                        ? "~/images/default_profile_female.png"
                        : "~/images/default_profile_male.png");
                }

                // Show the recipient's name and account number on the card
                lblRecipientName.Text = reader["FullName"].ToString();
                lblRecipientAccount.Text = reader["AccountNo"].ToString();

                // Save the gender in the hidden field for later use
                hfRecipientGender.Value = gender;

                // Make the recipient card visible
                pnlRecipient.Visible = true;
            }

            // Close the database connection
            reader.Close();
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        // Runs when the user clicks the Check button
        protected void btnCheckRecipient_Click(object sender, EventArgs e)
        {
            // Get what the user typed in the account number box
            string recipientAccNo = txtRecipient.Text.Trim();
            string senderUsername = Session["Username"].ToString();

            // Connect to the database
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Check if the user is trying to send money to themselves
            SqlCommand cmdSelf = new SqlCommand(
                "SELECT COUNT(*) FROM Users WHERE AccountNo=@AccountNo AND Username=@Username", conn);
            cmdSelf.Parameters.AddWithValue("@AccountNo", recipientAccNo);
            cmdSelf.Parameters.AddWithValue("@Username", senderUsername);
            int selfCount = (int)cmdSelf.ExecuteScalar();
            cmdSelf.Dispose();

            // If the user is sending to themselves, stop and show an error
            if (selfCount > 0)
            {
                conn.Close();
                conn.Dispose();
                pnlRecipient.Visible = false;
                hfRecipientAccount.Value = "";
                hfRecipientGender.Value = "";
                SetSendFieldsEnabled(false);
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "You cannot send money to yourself.";
                return;
            }

            // Search for the recipient account in the database
            SqlCommand cmd = new SqlCommand(
                "SELECT AccountNo, FullName, Gender, ProfilePicture, ProfilePictureType FROM Users WHERE AccountNo=@AccountNo",
                conn);
            cmd.Parameters.AddWithValue("@AccountNo", recipientAccNo);

            SqlDataReader reader = cmd.ExecuteReader();

            // If the recipient account is found
            if (reader.Read())
            {
                // Get the recipient's gender
                string gender = reader["Gender"] != DBNull.Value
                    ? reader["Gender"].ToString().ToLower() : "male";

                // Show the recipient's profile photo
                if (reader["ProfilePicture"] != DBNull.Value)
                {
                    byte[] imageBytes = (byte[])reader["ProfilePicture"];
                    string mimeType = reader["ProfilePictureType"] != DBNull.Value
                        ? reader["ProfilePictureType"].ToString().Trim() : "jpeg";
                    if (!mimeType.StartsWith("image/"))
                        mimeType = "image/" + mimeType;
                    imgRecipient.ImageUrl = "data:" + mimeType + ";base64," + Convert.ToBase64String(imageBytes);
                }
                else
                {
                    // Use default photo if no photo is saved
                    imgRecipient.ImageUrl = ResolveUrl(
                        gender == "female"
                        ? "~/images/default_profile_female.png"
                        : "~/images/default_profile_male.png");
                }

                // Show the recipient's name and account number
                lblRecipientName.Text = reader["FullName"].ToString();
                lblRecipientAccount.Text = reader["AccountNo"].ToString();

                // Save the account number and gender in hidden fields
                hfRecipientAccount.Value = reader["AccountNo"].ToString();
                hfRecipientGender.Value = gender;

                // Show the recipient card
                pnlRecipient.Visible = true;

                // Unlock the amount, password, and send button
                SetSendFieldsEnabled(true);

                lblMessage.ForeColor = System.Drawing.Color.YellowGreen;
                lblMessage.Text = "Recipient found!";
            }
            else
            {
                // Recipient not found — hide the card, clear saved data, lock fields
                hfRecipientAccount.Value = "";
                hfRecipientGender.Value = "";
                pnlRecipient.Visible = false;
                SetSendFieldsEnabled(false);
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Recipient not found.";
            }

            // Close the database connection
            reader.Close();
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        // Checks if the amount can be divided by 100
        // This is called automatically by the CustomValidator on the page
        protected void cvDivisible_ServerValidate(object source,
            System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // Convert the typed value to a whole number
            // then check if dividing it by 100 leaves no remainder
            int amount;
            args.IsValid = int.TryParse(args.Value, out amount) && (amount % 100 == 0);
        }

        // Checks if the user has enough balance to send the amount
        // This is called automatically by the CustomValidator on the page
        protected void cvFunds_ServerValidate(object source,
            System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // Convert the typed value to a decimal number
            decimal amount;
            if (!decimal.TryParse(args.Value, out amount))
            {
                // If it cannot be converted, mark as invalid and stop
                args.IsValid = false;
                return;
            }

            // Connect to the database
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // Get the user's current balance from the database
            SqlCommand cmd = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());

            object result = cmd.ExecuteScalar();

            // Check if the balance is enough to cover the amount
            args.IsValid = (result != null && result != DBNull.Value)
                           && Convert.ToDecimal(result) >= amount;

            // Close the database connection
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        // Runs when the user clicks the Send Money button
        protected void btsend_Click(object sender, EventArgs e)
        {
            // If no recipient was selected yet, show an error and stop
            if (string.IsNullOrEmpty(hfRecipientAccount.Value))
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Please look up a recipient first using the Check button.";
                return;
            }

            // Run all the send validators to make sure everything is valid
            Page.Validate("SendGroup");
            if (!Page.IsValid)
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Please fix the errors above before sending.";
                return;
            }

            // Get the sender's username and the recipient's account number
            string senderUsername = Session["Username"].ToString();
            string recipientAccNo = hfRecipientAccount.Value.Trim();

            // Convert the typed amount to a number
            decimal amount;
            if (!decimal.TryParse(txtAmount.Text.Trim(), out amount))
            {
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Invalid amount entered.";
                return;
            }

            string password = txtPassword.Text;

            // Connect to the database
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDB"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            // STEP 1: Check if the password the user typed is correct
            SqlCommand cmdPwd = new SqlCommand(
                "SELECT COUNT(*) FROM Users WHERE Username=@Username AND Password=@Password", conn);
            cmdPwd.Parameters.AddWithValue("@Username", senderUsername);
            cmdPwd.Parameters.AddWithValue("@Password", password);
            int pwdMatch = (int)cmdPwd.ExecuteScalar();
            cmdPwd.Dispose();

            // If the password is wrong, stop
            if (pwdMatch == 0)
            {
                conn.Close();
                conn.Dispose();
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Incorrect password. Transfer cancelled.";
                return;
            }

            // STEP 2: Check if the sender has enough balance
            decimal senderBalance = 0;
            SqlCommand cmdBal = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmdBal.Parameters.AddWithValue("@Username", senderUsername);
            object bal = cmdBal.ExecuteScalar();
            senderBalance = (bal != null && bal != DBNull.Value) ? Convert.ToDecimal(bal) : 0;
            cmdBal.Dispose();

            // If not enough balance, stop
            if (senderBalance < amount)
            {
                conn.Close();
                conn.Dispose();
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Insufficient balance. Transfer cancelled.";
                return;
            }

            // STEP 3: Make sure the recipient account still exists
            SqlCommand cmdRecExists = new SqlCommand(
                "SELECT COUNT(*) FROM Users WHERE AccountNo=@AccountNo", conn);
            cmdRecExists.Parameters.AddWithValue("@AccountNo", recipientAccNo);
            int recExists = (int)cmdRecExists.ExecuteScalar();
            cmdRecExists.Dispose();

            // If the recipient no longer exists, stop
            if (recExists == 0)
            {
                conn.Close();
                conn.Dispose();
                lblMessage.ForeColor = System.Drawing.Color.LightCoral;
                lblMessage.Text = "Recipient account no longer exists. Transfer cancelled.";
                return;
            }

            // STEP 4: Get the sender's full name for the recipient's record
            string senderFullName = "";
            SqlCommand cmdSenderName = new SqlCommand(
                "SELECT FullName FROM Users WHERE Username=@Username", conn);
            cmdSenderName.Parameters.AddWithValue("@Username", senderUsername);
            object name = cmdSenderName.ExecuteScalar();
            senderFullName = (name != null && name != DBNull.Value) ? name.ToString() : senderUsername;
            cmdSenderName.Dispose();

            // STEP 5: Subtract the amount from the sender's balance
            SqlCommand cmdDeduct = new SqlCommand(
                "UPDATE Users SET Balance = Balance - @Amount, TotalSent = TotalSent + @Amount WHERE Username=@Username",
                conn);
            cmdDeduct.Parameters.AddWithValue("@Amount", amount);
            cmdDeduct.Parameters.AddWithValue("@Username", senderUsername);
            cmdDeduct.ExecuteNonQuery();
            cmdDeduct.Dispose();

            // STEP 6: Add the amount to the recipient's balance
            SqlCommand cmdAdd = new SqlCommand(
                "UPDATE Users SET Balance = Balance + @Amount WHERE AccountNo=@AccountNo", conn);
            cmdAdd.Parameters.AddWithValue("@Amount", amount);
            cmdAdd.Parameters.AddWithValue("@AccountNo", recipientAccNo);
            cmdAdd.ExecuteNonQuery();
            cmdAdd.Dispose();

            // STEP 7: Save the transaction in the Transactions table
            SqlCommand cmdLog = new SqlCommand(
                "INSERT INTO Transactions (SenderUsername, RecipientAccountNo, Amount, DateTrans) VALUES (@Sender, @Recipient, @Amount, @DateTrans)",
                conn);
            cmdLog.Parameters.AddWithValue("@Sender", senderUsername);
            cmdLog.Parameters.AddWithValue("@Recipient", recipientAccNo);
            cmdLog.Parameters.AddWithValue("@Amount", amount);
            cmdLog.Parameters.AddWithValue("@DateTrans", DateTime.Now);
            cmdLog.ExecuteNonQuery();
            cmdLog.Dispose();

            // STEP 8: Save this as a Send record in the DW_History table
            SqlCommand cmdHistory = new SqlCommand(
                "INSERT INTO DW_History (Username, Type, Amount, Date) VALUES (@Username, 'Send', @Amount, @Date)",
                conn);
            cmdHistory.Parameters.AddWithValue("@Username", senderUsername);
            cmdHistory.Parameters.AddWithValue("@Amount", amount);
            cmdHistory.Parameters.AddWithValue("@Date", DateTime.Now);
            cmdHistory.ExecuteNonQuery();
            cmdHistory.Dispose();

            // STEP 9: Get the sender's new balance after the deduction
            decimal senderNewBalance = 0;
            SqlCommand cmdNewBal = new SqlCommand(
                "SELECT Balance FROM Users WHERE Username=@Username", conn);
            cmdNewBal.Parameters.AddWithValue("@Username", senderUsername);
            object newBal = cmdNewBal.ExecuteScalar();
            senderNewBalance = (newBal != null && newBal != DBNull.Value) ? Convert.ToDecimal(newBal) : 0;
            cmdNewBal.Dispose();

            // STEP 10: Save a statement row for the sender showing money went out
            SqlCommand cmdStmtSender = new SqlCommand(
                @"INSERT INTO Statement (Username, Type, Date, Debit, Credit, Balance, SentTo, Received_From)
                  VALUES (@Username, 'Send', @Date, @Amount, 0, @NewBalance, @SentTo, NULL)",
                conn);
            cmdStmtSender.Parameters.AddWithValue("@Username", senderUsername);
            cmdStmtSender.Parameters.AddWithValue("@Date", DateTime.Now);
            cmdStmtSender.Parameters.AddWithValue("@Amount", amount);
            cmdStmtSender.Parameters.AddWithValue("@NewBalance", senderNewBalance);
            cmdStmtSender.Parameters.AddWithValue("@SentTo", recipientAccNo);
            cmdStmtSender.ExecuteNonQuery();
            cmdStmtSender.Dispose();

            // STEP 11: Get the recipient's username and new balance
            string recipientUsername = "";
            decimal recipientBalance = 0;
            SqlCommand cmdRec = new SqlCommand(
                "SELECT Username, Balance FROM Users WHERE AccountNo=@AccountNo", conn);
            cmdRec.Parameters.AddWithValue("@AccountNo", recipientAccNo);
            SqlDataReader rdr = cmdRec.ExecuteReader();
            if (rdr.Read())
            {
                recipientUsername = rdr["Username"].ToString();
                recipientBalance = Convert.ToDecimal(rdr["Balance"]);
            }
            rdr.Close();
            cmdRec.Dispose();

            // STEP 12: Save a statement row for the recipient showing money came in
            if (!string.IsNullOrEmpty(recipientUsername))
            {
                SqlCommand cmdStmtRec = new SqlCommand(
                    @"INSERT INTO Statement (Username, Type, Date, Debit, Credit, Balance, SentTo, Received_From)
                      VALUES (@RecipientUsername, 'Receive', @Date, 0, @Amount, @RecipientBalance, NULL, @SenderFullName)",
                    conn);
                cmdStmtRec.Parameters.AddWithValue("@RecipientUsername", recipientUsername);
                cmdStmtRec.Parameters.AddWithValue("@Date", DateTime.Now);
                cmdStmtRec.Parameters.AddWithValue("@Amount", amount);
                cmdStmtRec.Parameters.AddWithValue("@RecipientBalance", recipientBalance);
                cmdStmtRec.Parameters.AddWithValue("@SenderFullName", senderFullName);
                cmdStmtRec.ExecuteNonQuery();
                cmdStmtRec.Dispose();
            }

            // Close the database connection
            conn.Close();
            conn.Dispose();

            // Clear all the boxes and reset the page back to the start
            txtAmount.Text = "";
            txtPassword.Text = "";
            txtRecipient.Text = "";
            hfRecipientAccount.Value = "";
            hfRecipientGender.Value = "";
            pnlRecipient.Visible = false;

            // Lock the fields again until the user finds a new recipient
            SetSendFieldsEnabled(false);

            // Refresh the balance shown on the page
            LoadBalance();

            // Show a success message
            lblMessage.ForeColor = System.Drawing.Color.YellowGreen;
            lblMessage.Text = $"₱{amount:N2} sent successfully!";
        }
    }
}