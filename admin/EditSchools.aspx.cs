using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.Linq.SqlClient;

public partial class admin_EditSchools : System.Web.UI.Page {

    TranEquivDataContext dc;

    protected void Page_Load(object sender, EventArgs e) {
        dc = new TranEquivDataContext();
        if (!IsPostBack) {
            string AvailableLetters = "";
            foreach (var result in dc.AvailableSchoolLetters()) {
                if (AvailableLetters != "")
                    AvailableLetters += ",";
                AvailableLetters += result.Letter.ToString();
            }
            Alphabet1.AvailableLetters = AvailableLetters;
        }
    }
    protected void LinqDataSourceSchools_Selecting(object sender, LinqDataSourceSelectEventArgs e) {
        e.Result = from s in dc.Schools where SqlMethods.Like(s.SchoolName, Alphabet1.SelectedCharacter.ToString() + '%') select s;
    }
    protected void Alphabet1_SelectedCharacterChanged(object sender, SunGard.Web.UI.WebControls.AlphabetEventArgs e) {
        gvSchools.EditIndex = -1;
        gvSchools.DataBind();
    }
}
