using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GetCourseID
/// </summary>
public static class GetCourseID
{
    public static int CourseIDLookup(string sCourseName)
    {
        using (TranEquivDataContext db = new TranEquivDataContext())
        {
            return db.GetCourseID(sCourseName.Replace("-", " ")).First().Column1.Value;
        }
    }
}