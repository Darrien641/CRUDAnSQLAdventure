using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRUDAnSQLAdventure
{
    public static class db
    {
        public static string GetConnection()
        {
            string DBConn = System.Configuration.ConfigurationManager.AppSettings["DBConn"].ToString();
            return DBConn;
        }

    }
}
