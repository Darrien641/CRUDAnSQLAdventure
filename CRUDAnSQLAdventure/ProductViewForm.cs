using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

namespace CRUDAnSQLAdventure
{
    public partial class ProductViewForm : Form
    {
        public ProductViewForm()
        {
            InitializeComponent();
            getData();
        }
        public void getData()
        {
            using (SqlConnection conn = new SqlConnection(db.GetConnection()))
            {
                SqlCommand cmd = new SqlCommand("GetProductSummary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                dataGridView1.DataSource = dt;
            }


        }
    }
}
