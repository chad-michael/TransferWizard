using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class SchoolMenu : System.Web.UI.Page
{
    private TranEquivDataContext dc;
    private School school;
    private Dictionary<Guid, List<CourseInfo>> TransferCourses;
    private Dictionary<Guid, List<CourseInfo>> DeltaCourses;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["SchoolID"] == null || Request["SchoolID"].Trim() == "")
            Response.Redirect("~/SchoolList.aspx", true);

        dc = new TranEquivDataContext();
        TransferCourses = new Dictionary<Guid, List<CourseInfo>>();
        DeltaCourses = new Dictionary<Guid, List<CourseInfo>>();

        try
        {
            school = dc.Schools.First(s => s.SchoolID == new Guid(Request["SchoolID"]));
        }
        catch
        {
            Response.Redirect("~/SchoolList.aspx", true);
        }

        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(school.Website))
            {
                lnkSchoolLink.NavigateUrl = school.Website;
                lnkSchoolLink.Text = "View transfer courses from Delta College to " + school.SchoolName;
                pnlSchoolLink.Visible = true;
            }

            litSchoolName.Text = school.SchoolName;

            ddDepartments.DataTextField = "DepartmentName";
            ddDepartments.DataValueField = "DepartmentID";
            ddDepartments.DataSource = dc.DepartmentsForSchoolTransfers(new Guid(Request["SchoolID"]));
            ddDepartments.DataBind();

            ddSchools.DataTextField = "SchoolName";
            ddSchools.DataValueField = "SchoolId";
            ddSchools.DataSource = from s in dc.Schools orderby s.SchoolName select s;
            ddSchools.DataBind();
        }
    }

    /**/

    public string GetTransferCourseNumbers(object LineItemID)
    {
        FillTransferCourses((Guid)LineItemID);
        StringBuilder sb = new StringBuilder();
        foreach (CourseInfo c in TransferCourses[(Guid)LineItemID])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseNumber);
        }
        return sb.ToString();
    }

    public string GetTransferCourseNames(object LineItemID)
    {
        FillTransferCourses((Guid)LineItemID);
        StringBuilder sb = new StringBuilder();
        foreach (CourseInfo c in TransferCourses[(Guid)LineItemID])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseName);
        }
        return sb.ToString();
    }

    public string GetDeltaCourseNumbers(object LineItemID)
    {
        FillDeltaCourses((Guid)LineItemID);
        StringBuilder sb = new StringBuilder();
        foreach (CourseInfo c in DeltaCourses[(Guid)LineItemID])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            if (c.CourseID != 0)
            {
                sb.Append("<a href=\"#\" onClick=\"window.open('https://public.delta.edu/catalog/Pages/CourseDetail.aspx?CourseID=" + c.CourseID.ToString() + "', null, 'width=640, height=480,resizable=yes, scrollbars=yes')\">" + c.CourseNumber + "</a>");
            }
            else
            {
                sb.Append("<a href=\"#\" onClick=\"window.open('https://public.delta.edu/catalog/Pages/CoursesByTitle.aspx?CourseSearch=" + c.CourseNumber.Split("-".ToCharArray())[0] + "', null, 'width=640, height=480,resizable=yes, scrollbars=yes')\">" + c.CourseNumber + "</a>");
            }
        }
        return sb.ToString();
    }

    public string GetDeltaCourseNames(object LineItemID)
    {
        FillDeltaCourses((Guid)LineItemID);
        StringBuilder sb = new StringBuilder();
        foreach (CourseInfo c in DeltaCourses[(Guid)LineItemID])
        {
            if (sb.Length > 0)
                sb.Append("<br/>");
            sb.Append(c.CourseName);
        }
        return sb.ToString();
    }

    private void FillTransferCourses(Guid LineItemID)
    {
        if (!TransferCourses.Keys.Contains(LineItemID))
            TransferCourses.Add(LineItemID, (from c in dc.TransferCourses where c.LineItemID == LineItemID select new CourseInfo { CourseNumber = c.CourseNumber, CourseName = c.CourseName }).ToList());
    }

    private void FillDeltaCourses(Guid LineItemID)
    {
        if (!DeltaCourses.Keys.Contains(LineItemID))
            DeltaCourses.Add(LineItemID, (from c in dc.DeltaCourses where c.LineItemID == LineItemID select new CourseInfo { CourseNumber = c.CourseNumber, CourseName = c.CourseName, CourseID = GetCourseID.CourseIDLookup(c.CourseNumber) }).ToList());
    }
}