using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CRUDAnSQLAdventure
{
    public partial class CustomerMenu : Form
    {
     
        public CustomerMenu()
        {
            InitializeComponent();
            getData();
        }

        public void ClearTextBoxes()
        {
            Address1Box.Text = string.Empty;
            Address2Box.Text = string.Empty;
            CityBox.Text = string.Empty;
            StateBox.Text = string.Empty;
            CountryBox.Text = string.Empty;
            PostalCodeBox.Text = string.Empty;
            AddressTypeBox.Text = string.Empty;
            TitleTextBox.Text = string.Empty;
            FirstNameTextBox.Text = string.Empty;
            LastNameBox.Text = string.Empty;
            MiddleNameBox.Text = string.Empty;
            SuffixBox.Text = string.Empty;
            CompanyNameBox.Text = string.Empty;
            SalesPersonBox.Text = string.Empty;
            EmailBox.Text = string.Empty;
            PhoneBox.Text = string.Empty;
            IDTextBox.Text = string.Empty;

        }
        private void Create_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                SqlCommand cmd = new SqlCommand("AddCustomerAddress", conn);
                SqlCommand cmd2 = new SqlCommand("AddNewCustomer", conn);
                SqlCommand cmd3 = new SqlCommand("InsertAddress", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd3.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CustomerID", IDTextBox.Text);
                cmd.Parameters.AddWithValue("@AddID", AddressIDTextBox.Text);
                cmd.Parameters.AddWithValue("@AddressType", AddressTypeBox.Text);

                cmd2.Parameters.AddWithValue("@Title", TitleTextBox.Text);
                cmd2.Parameters.AddWithValue("@FirstName", FirstNameTextBox.Text);
                cmd2.Parameters.AddWithValue("@middleName", MiddleNameBox.Text);
                cmd2.Parameters.AddWithValue("@lastName", LastNameBox.Text);
                cmd2.Parameters.AddWithValue("@suffix", SuffixBox.Text);
                cmd2.Parameters.AddWithValue("@companyName", CompanyNameBox.Text);
                cmd2.Parameters.AddWithValue("@salesPerson", SalesPersonBox.Text);
                cmd2.Parameters.AddWithValue("@emailAddress", EmailBox.Text);
                cmd2.Parameters.AddWithValue("@phone", PhoneBox.Text);
                cmd2.Parameters.AddWithValue("@PasswordHash", string.Empty);
                cmd2.Parameters.AddWithValue("@PasswordSalt", string.Empty);

                cmd3.Parameters.AddWithValue("@addressLine1", Address1Box.Text);
                cmd3.Parameters.AddWithValue("@addressLine2", Address2Box.Text);
                cmd3.Parameters.AddWithValue("@city", Address1Box.Text);
                cmd3.Parameters.AddWithValue("@stateProvince", Address2Box.Text);
                cmd3.Parameters.AddWithValue("@countryRegion", Address1Box.Text);
                cmd3.Parameters.AddWithValue("@postalCode", Address2Box.Text);

                conn.Open();
                cmd.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
            }
            getData();
            ClearTextBoxes();
        }

        void getData()
        {
            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                SqlCommand cmd = new SqlCommand("GetCustomerSummary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                dataGridView1.DataSource = dt;
            }
        }

        private void Delete_Click(object sender, EventArgs e)
        {
            int ID = Convert.ToInt32(textBox1.Text);
            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                SqlCommand cmd = new SqlCommand("DeleteCustomer", conn);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", ID);
                conn.Open();
                cmd.ExecuteNonQuery();

            }
            getData();
        }

        private void Update_Click(object sender, EventArgs e)
        {
            
            string address1 = Address1Box.Text;
            string address2 = Address2Box.Text;
            string city = CityBox.Text;
            string StateProvince = StateBox.Text;
            string Country = CountryBox.Text;
            string PostalCode = PostalCodeBox.Text;
            string AddressType = AddressTypeBox.Text;
            string Title = TitleTextBox.Text;
            string Firstname = FirstNameTextBox.Text;
            string LastName = LastNameBox.Text;
            string MiddleName = MiddleNameBox.Text;
            string Suffix = SuffixBox.Text;
            string CompanyName = CompanyNameBox.Text;
            string SalesPerson = SalesPersonBox.Text;
            string Email = EmailBox.Text;
            string Phone = PhoneBox.Text;
            int ID = Convert.ToInt32(IDTextBox.Text);

            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                SqlCommand cmd = new SqlCommand("UpdateCustomer", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID",ID);
                cmd.Parameters.AddWithValue("@addyType", AddressType);
                cmd.Parameters.AddWithValue("@Address1", address1);
                cmd.Parameters.AddWithValue("@Address2", address2);
                cmd.Parameters.AddWithValue("@City", city);
                cmd.Parameters.AddWithValue("@State", StateProvince);
                cmd.Parameters.AddWithValue("@Country", Country);
                cmd.Parameters.AddWithValue("@PostalCode", PostalCode);
                cmd.Parameters.AddWithValue("@Title", Title);
                cmd.Parameters.AddWithValue("@FirstName", Firstname);
                cmd.Parameters.AddWithValue("@Middle", MiddleName);
                cmd.Parameters.AddWithValue("@LastName", LastName);
                cmd.Parameters.AddWithValue("@CompanyName", CompanyName);
                cmd.Parameters.AddWithValue("@SalesPerson", SalesPerson);
                cmd.Parameters.AddWithValue("@Email", Email);
                cmd.Parameters.AddWithValue("@Phone", Phone);
                cmd.Parameters.AddWithValue("@Suffix", Suffix);


                conn.Open();
                cmd.ExecuteNonQuery();
            }
            getData();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            ClearTextBoxes();
            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                
                int ID = Convert.ToInt32(IDTextBox.Text);
               
                SqlCommand cmd = new SqlCommand("PopulateData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", ID);
              
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Read();

                TitleTextBox.Text = dr.GetString(1);
                FirstNameTextBox.Text = dr.GetString(2);
                if (dr.IsDBNull(3))
                {
                    MiddleNameBox.Text = string.Empty;
                }
                else
                {
                    MiddleNameBox.Text = dr.GetString(3);
                }
                LastNameBox.Text = dr.GetString(4);
                if (dr.IsDBNull(5))
                {
                    MiddleNameBox.Text = string.Empty;
                }
                else
                {
                    SuffixBox.Text = dr.GetString(5);
                }
                CompanyNameBox.Text = dr.GetString(6);
                SalesPersonBox.Text = dr.GetString(7);
                EmailBox.Text = dr.GetString(8);
                PhoneBox.Text = dr.GetString(9);
                if (dr.IsDBNull(15))
                {
                    Address1Box.Text = string.Empty;
                }
                else
                {
                    Address1Box.Text = dr.GetString(15);
                }
                if (dr.IsDBNull(16))
                {
                    Address2Box.Text = string.Empty;
                }
                else
                {
                    Address2Box.Text = dr.GetString(16);
                }
                if (dr.IsDBNull(17))
                {
                    CityBox.Text = string.Empty;
                }
                else
                {
                    CityBox.Text = dr.GetString(17);
                }
                
                if (dr.IsDBNull(18))
                {
                    StateBox.Text = string.Empty;
                }
                else
                {
                    StateBox.Text = dr.GetString(18);
                }
                if (dr.IsDBNull(19))
                {
                    CountryBox.Text = string.Empty;
                }
                else
                {
                    CountryBox.Text = dr.GetString(19);
                }
                if (dr.IsDBNull(20))
                {
                    PostalCodeBox.Text = string.Empty;
                }
                else
                {
                    PostalCodeBox.Text = dr.GetString(20);
                }
                if (dr.IsDBNull(22))
                {
                    PostalCodeBox.Text = string.Empty;
                }
                else
                {
                    AddressTypeBox.Text = dr.GetString(22);
                }
            }
            
        }
    }
}
