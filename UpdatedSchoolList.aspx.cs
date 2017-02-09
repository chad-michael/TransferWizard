using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SchoolList : System.Web.UI.Page
{
    private TranEquivDataContext _dc;
    private School _school;
    private Dictionary<Guid, List<CourseInfo>> _transferCourses;
    private Dictionary<Guid, List<CourseInfo>> _deltaCourses;

    private readonly string _strConnString = ConfigurationManager.ConnectionStrings["TranEquivConnectionString"].ConnectionString;

    public void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //reset things
        dbGrid.Visible = false;
        btnSearch.Enabled = true;
        btnSearch.Text = "SEARCH";
        ddDepartments.Items.Clear();

        ddDepartments.DataTextField = "DepartmentName";
        ddDepartments.DataValueField = "DepartmentID";
        ddDepartments.DataSource = _dc.DepartmentsForSchoolTransfers(new Guid(ddSchools.SelectedValue)).ToList().Count > 0 ? _dc.DepartmentsForSchoolTransfers(new Guid(ddSchools.SelectedValue)) : null;

        var depts = _dc.DepartmentsForSchoolTransfers(new Guid(ddSchools.SelectedValue)).ToList();
        var deptsCount = depts.Count;

        if (ddDepartments.DataSource == null)
        {
            ddDepartments.Items.Insert(0, new ListItem("-- No Equivilencies available at this time --", ""));
            btnSearch.Enabled = false;
        }

        ddDepartments.DataBind();
    }

    public void btnSearch_Click(Object sender, EventArgs e)
    {
        // When the button is clicked, change the button text, and disable it.
        Button clickedButton = (Button)sender;
        //clickedButton.Text = "...SEARCHING...";
        clickedButton.Enabled = false;

        var school = new School();
        try
        {
            school = _dc.Schools.First(s => s.SchoolID == new Guid(ddSchools.SelectedValue));
        }
        catch
        {
            Response.Redirect("~/UpdatedSchoolList.aspx", true);
        }

        const string strQuery = "SELECT * FROM [LineItems] " +
                                "WHERE (([SchoolID] = @SchoolID) " +
                                "AND ([DepartmentID] = @DepartmentID))";

        FillTransferCourses(new Guid(ddSchools.SelectedValue));
        FillDeltaCourses(new Guid(ddSchools.SelectedValue));

        SqlConnection con = new SqlConnection(_strConnString);
        SqlCommand cmd = new SqlCommand(strQuery)
        {
            CommandType = CommandType.Text,
            CommandText = "SELECT * FROM [LineItems] " +
                          "WHERE (([SchoolID] = @SchoolID) " +
                          "AND ([DepartmentID] = @DepartmentID))"
        };

        if (ddDepartments.SelectedValue != "")
        {
            cmd.Parameters.Add("@SchoolID", SqlDbType.VarChar).Value = ddSchools.SelectedValue;
            cmd.Parameters.Add("@DepartmentID", SqlDbType.VarChar).Value = ddDepartments.SelectedValue;
        }

        if (ddDepartments.SelectedValue != "" && ddSchools.SelectedValue != "")
        {
            gvCourses.DataSource = GetData(cmd);
            gvCourses.DataBind();

            gvDeltaCourses.DataSource = GetData(cmd);
            gvDeltaCourses.DataBind();

            litSchoolName.Text = school.SchoolName;
            litDeltaName.Text = ("Delta College").ToUpper();

            dbGrid.Visible = true;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _dc = new TranEquivDataContext();
        _transferCourses = new Dictionary<Guid, List<CourseInfo>>();
        _deltaCourses = new Dictionary<Guid, List<CourseInfo>>();
        var schoolsWithEquivilenciesList = new List<School>();

        if (!IsPostBack)
        {
            dbGrid.Visible = false;
            btnSearch.Text = "SEARCH";

            ddDepartments.SelectedIndex = -1;
            ddDepartments.Text = "Select your Subject";
            ddDepartments.SelectedValue = "";

            ddSchools.SelectedIndex = -1;
            ddSchools.Text = "Select your College or University";
            ddSchools.SelectedValue = "";

            ddSchools.DataTextField = "SchoolName";
            ddSchools.DataValueField = "SchoolId";

            ddSchools.DataSource = from s in _dc.Schools orderby s.SchoolName select s;
            //var lower = ddSchools.Text.ToLower();
            ddSchools.DataBind();

            ddDepartments.DataTextField = "DepartmentName";
            ddDepartments.DataValueField = "DepartmentID";
            ddDepartments.DataSource = null;
            ddDepartments.DataBind();
        }
    }

    private DataTable GetData(SqlCommand cmd)
    {
        var dt = new DataTable();
        var con = new SqlConnection(_strConnString);
        using (var sda = new SqlDataAdapter())
        {
            cmd.CommandType = CommandType.Text;
            cmd.Connection = con;
            con.Open();
            sda.SelectCommand = cmd;
            sda.Fill(dt);
            return dt;
        }
    }

    public string BindData()
    {
        pnlCourses.Visible = true;

        return null;
    }

    public string GetTransferCourseNumbers(object LineItemId)
    {
        FillTransferCourses((Guid)LineItemId);
        var sb = new StringBuilder();
        foreach (var c in _transferCourses[(Guid)LineItemId])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseNumber);
        }
        return sb.ToString();
    }

    public string GetTransferCourseNames(object lineItemId)
    {
        FillTransferCourses((Guid)lineItemId);
        var sb = new StringBuilder();
        foreach (var c in _transferCourses[(Guid)lineItemId])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseName);
        }
        return sb.ToString();
    }

    public string GetDeltaCourseNumbers(object lineItemId)
    {
        FillDeltaCourses((Guid)lineItemId);
        var sb = new StringBuilder();
        foreach (var c in _deltaCourses[(Guid)lineItemId])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            if (c.CourseID != 0)
            {
                //sb.Append("<a href=\"#\" onClick=\"window.open('https://public.delta.edu/catalog/Pages/CourseDetail.aspx?CourseID=" + c.CourseID.ToString() + "', null, 'width=640, height=480,resizable=yes, scrollbars=yes')\">" + c.CourseNumber + "</a>");
                //sb.Append(c.CourseNumber); -- for no hyperlink
                //Makes course number a hyper link <a>
                //sb.Append(@"<a href=""#"" onClick=""window.open('https://public.delta.edu/catalog/Pages/CoursesByNumber.aspx', null, 'width=640, height=480, resizable=yes, scrollbars=yes class=MyriadPro-Regular')"">" + c.CourseNumber + "</a>");
                sb.Append(c.CourseNumber);
            }
            else
            {
                //sb.Append("<a href=\"#\" onClick=\"window.open('https://public.delta.edu/catalog/Pages/CoursesByTitle.aspx?CourseSearch=" + c.CourseNumber.Split("-".ToCharArray())[0] + "', null, 'width=640, height=480,resizable=yes, scrollbars=yes')\">" + c.CourseNumber + "</a>");
                //sb.Append(c.CourseNumber); -- for no hyperlink
                //Makes course number a hyper link <a>
                //sb.Append(@"<a href=""#"" onClick=""window.open('https://public.delta.edu/catalog/Pages/CoursesByNumber.aspx', null, 'width=640, height=480, resizable=yes, scrollbars=yes class=MyriadPro-Regular')"">" + c.CourseNumber + "</a>");
                sb.Append(c.CourseNumber);
            }
        }
        return sb.ToString();
    }

    public string GetDeltaCourseNames(object lineItemId)
    {
        FillDeltaCourses((Guid)lineItemId);
        StringBuilder sb = new StringBuilder();
        foreach (CourseInfo c in _deltaCourses[(Guid)lineItemId])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseName);
        }
        return sb.ToString();
    }

    private void FillTransferCourses(Guid lineItemId)
    {
        if (!_transferCourses.Keys.Contains(lineItemId))
            _transferCourses.Add(lineItemId, (from c in _dc.TransferCourses where c.LineItemID == lineItemId select new CourseInfo { CourseNumber = c.CourseNumber, CourseName = c.CourseName }).ToList());
    }

    private void FillDeltaCourses(Guid lineItemId)
    {
        if (!_deltaCourses.Keys.Contains(lineItemId))
            _deltaCourses.Add(lineItemId, (from c in _dc.DeltaCourses where c.LineItemID == lineItemId select new CourseInfo { CourseNumber = c.CourseNumber, CourseName = c.CourseName, CourseID = GetCourseID.CourseIDLookup(c.CourseNumber) }).ToList());
    }

    protected void Alphabet1_SelectedCharacterChanged(object sender, SunGard.Web.UI.WebControls.AlphabetEventArgs e)
    {
        //LoadSchools();
    }

    private void LoadSchools()
    {
        //string Letter = "";
        //if (Alphabet1.SelectedCharacter != '%')
        //    Letter = Alphabet1.SelectedCharacter.ToString();
        //rptSchools.DataSource = from s in dc.Schools where s.SchoolName.StartsWith(Letter) orderby s.SchoolName select s;
        //rptSchools.DataBind();
        //string AvailableLetters = "";
        //foreach (var result in dc.AvailableSchoolLetters())
        //{
        //    if (AvailableLetters != "")
        //        AvailableLetters += ",";
        //    AvailableLetters += result.Letter.ToString();
        //}
        //Alphabet1.AvailableLetters = AvailableLetters;
    }

    public string Highlight(object website)
    {
        var site = (string)website;
        return !string.IsNullOrEmpty(site) ? "highlight" : "";
    }
}