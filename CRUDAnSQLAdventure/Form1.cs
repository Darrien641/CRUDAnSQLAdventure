using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CRUDAnSQLAdventure
{
    public partial class Form1 : Form
    {
        ProductViewForm pv = new ProductViewForm();
        CustomerMenu cv = new CustomerMenu();
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Visible = false;
            pv.ShowDialog();
            this.Visible = true;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Visible = false;
            cv.ShowDialog();
            this.Visible = true;
        }
    }
}
