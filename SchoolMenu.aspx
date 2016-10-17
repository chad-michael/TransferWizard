<%@ Page Language="C#" MasterPageFile="~/MasterPages/AppCustom.master" Theme="Default" AutoEventWireup="true" CodeFile="SchoolMenu.aspx.cs" Inherits="SchoolMenu" Title="Transfer Wizard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeaderTitle" runat="Server">
    Delta College Transfer Wizard
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="lsb" runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="crumbs" runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="rsbContent" runat="Server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="contentMain" runat="Server">

    <asp:Panel ID="pnlSchoolLink" Visible="false" runat="server">
        <div>
            <asp:HyperLink ID="lnkSchoolLink" runat="server" Target="_blank" CssClass="lnkExternal">View transfer courses from Delta College to SCHOOL NAME</asp:HyperLink>
        </div>
        <br />
    </asp:Panel>

    <div style="margin-top: 15px;">
        <span style="float: left;">
            <h1>Transfer courses from
                <asp:Literal ID="litSchoolName" runat="server"></asp:Literal>
                to Delta College</h1>
        </span><span style="float: left; padding: 5px 0 0 15px;">(<a href="SchoolList.aspx" style="color: #0000FF;">Change school</a>)</span>
        <div style="clear: both;"></div>
    </div>

    <div style="margin-top: 10px;">
        pick a school please:<br />
        <asp:DropDownList ID="ddSchools" runat="server" AutoPostBack="True"></asp:DropDownList>
    </div>

    <div style="margin-top: 10px;">
        What department you would like to view transfer equivalencies for?<br />
        <asp:DropDownList ID="ddDepartments" runat="server" AutoPostBack="True"></asp:DropDownList>
    </div>

    <div style="margin-top: 10px;">
        <sungard:GridView ID="gvCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" SkinID="GridView" DataSourceID="SqlDataSourceCourseMap">
            <Columns>
                <asp:TemplateField HeaderText="Course Number">
                    <ItemTemplate><%#GetTransferCourseNumbers(Eval("LineItemID")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Course Name">
                    <ItemTemplate><%#GetTransferCourseNames(Eval("LineItemID")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TransferCredits" HeaderText="Credit Hours" ReadOnly="True" SortExpression="TransferCredits" />
                <asp:TemplateField HeaderText="Delta Course Number">
                    <ItemTemplate><%#GetDeltaCourseNumbers(Eval("LineItemID")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Delta Course Name">
                    <ItemTemplate><%#GetDeltaCourseNames(Eval("LineItemID")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="DeltaCredits" HeaderText="Delta Credit Hours" SortExpression="DeltaCredits" />
            </Columns>
        </sungard:GridView>
        <asp:SqlDataSource ID="SqlDataSourceCourseMap" runat="server"
            ConnectionString="<%$ ConnectionStrings:TranEquivConnectionString %>"
            SelectCommand="SELECT * FROM [LineItems] WHERE (([SchoolID] = @SchoolID) AND ([DepartmentID] = @DepartmentID))">
            <SelectParameters>
                <asp:QueryStringParameter Name="SchoolID" QueryStringField="SchoolID" Type="String" />
                <asp:ControlParameter ControlID="ddDepartments" Name="DepartmentID" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>