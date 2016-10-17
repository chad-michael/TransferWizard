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

public partial class SchoolList : System.Web.UI.Page {
    TranEquivDataContext dc;
    protected void Page_Load(object sender, EventArgs e) {
        dc = new TranEquivDataContext();
        LoadSchools();
    }
    protected void Alphabet1_SelectedCharacterChanged(object sender, SunGard.Web.UI.WebControls.AlphabetEventArgs e) {
        LoadSchools();
    }
    private void LoadSchools() {
        string Letter = "";
        if(Alphabet1.SelectedCharacter != '%')
            Letter = Alphabet1.SelectedCharacter.ToString();
        rptSchools.DataSource = from s in dc.Schools where s.SchoolName.StartsWith(Letter) orderby s.SchoolName select s;
        rptSchools.DataBind();
        string AvailableLetters = "";
        foreach (var result in dc.AvailableSchoolLetters()) {
            if (AvailableLetters != "")
                AvailableLetters += ",";
            AvailableLetters += result.Letter.ToString();
        }
        Alphabet1.AvailableLetters = AvailableLetters;
    }
    public string Highlight(object Website) {
        string website = (string)Website;
        if (!string.IsNullOrEmpty(website))
            return "highlight";
        return "";
    }
}
