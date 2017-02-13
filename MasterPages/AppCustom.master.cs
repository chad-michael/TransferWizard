using System;

public partial class MasterPages_AppCustom : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        //var link = new System.Web.UI.HtmlControls.HtmlLink
        //{
        //    Href = ResolveUrl("~../Content/app.css")
        //};
        //link.Attributes["rel"] = "stylesheet";
        //link.Attributes["type"] = "text/css";

        //this.head.Controls.Add(link);
    }
}