using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPages_AppCustom : System.Web.UI.MasterPage {
    protected void Page_Load(object sender, EventArgs e) {

    }

	protected void Page_PreRender(object sender, EventArgs e)
	{
		System.Web.UI.HtmlControls.HtmlLink link = new System.Web.UI.HtmlControls.HtmlLink();
		link.Href = ResolveUrl("~/styles/Default.css");
		link.Attributes["rel"] = "stylesheet";
		link.Attributes["type"] = "text/css";

		this.head.Controls.Add(link);

	}
}
