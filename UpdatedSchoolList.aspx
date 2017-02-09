<%@ Page Language="C#" MasterPageFile="~/MasterPages/AppCustom.master" AutoEventWireup="true" CodeFile="UpdatedSchoolList.aspx.cs" Inherits="SchoolList" Title="Transfer Wizard" %>

<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content6" ContentPlaceHolderID="contentMain" runat="Server">

    <style>
        #content > div:nth-child(1) > div.header__logo {
            display: block;
            width: 100%;
            height: 160px;
            float: left;
            padding: 0px;
        }

            #content > div:nth-child(1) > div.header__logo > a {
                display: block;
                background: url("images/DeltaLogo.png") no-repeat;
                background-position: center;
                background-color: #00704A;
                color: #00704A;
                width: 240px;
                height: 155px;
                margin-left: 200px;
                -ms-border-bottom-right-radius: 15px !important;
                -ms-border-bottom-left-radius: 15px !important;
                -webkit-border-bottom-right-radius: 15px;
                -webkit-border-bottom-left-radius: 15px;
                -moz-border-radius-bottomright: 15px;
                -moz-border-radius-bottomleft: 15px;
                border-bottom-right-radius: 15px !important;
                border-bottom-left-radius: 15px !important;
            }

        body > div > div > a > span {
            min-height: 100px !important;
            display: block;
            position: relative;
            width: 100%;
            pointer-events: none;
        }
    </style>

    <div class="header__logo">
        <a href="https://www.delta.edu" title="Delta College"></a>
    </div>

    <script>
        // http://wwwdev.delta.edu/academics/transfer/index.html
        function goBack() {
            history.go(-1);
            return false;
        }
    </script>

    <div class="main page-wrap">
        <div>
            <%--
                "A" is different than "a" in TrendSlabOne Font
                <h1 style="clear: both; width: 100%; padding-top: 20px; text-align: left">DELTA COLLEGE TRANSFER WIZARD</h1>
            --%>

            <h1 style="clear: both; width: 100%; padding-top: 20px; text-align: left">Delta College Transfer Wizard</h1>
            <p style="clear: both; text-align: left;">
                Select a school from which you want to get more information about courses that transfer to Delta College.
            </p>
        </div>
        <div class="ddRow" style="width: 115%">
            <div class="alignleft">
                <asp:DropDownList
                    AppendDataBoundItems="true"
                    class="alignleft"
                    ID="ddSchools"
                    AutoPostBack="True"
                    runat="server"
                    Enabled="true"
                    OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
                    CssClass="btn">
                    <asp:ListItem Text="Select your College or University" Value="" />
                </asp:DropDownList>
            </div>
            <div class="alignright">
                <asp:DropDownList
                    AppendDataBoundItems="false"
                    class="alignright"
                    data-toggle="dropdown"
                    ID="ddDepartments"
                    AutoPostBack="False"
                    runat="server"
                    CssClass="btn">
                    <asp:ListItem Text="Select your Subject" Value="" />
                </asp:DropDownList>
            </div>
            <div>
                <asp:Button CssClass="btnSearch" ID="btnSearch" Text="SEARCH" OnClick="btnSearch_Click" runat="server" />
            </div>
        </div>

        <script>
            $('#<%=ddSchools.ClientID%>').change(function () {
                if ($(this).val() !== '0') {
                    <%=Page.ClientScript.GetPostBackEventReference(ddDepartments,"")%>;
                }
            });

            var sel = "";
            $(document).ready(function () {

                $(".link")
                    .click(function () {
                        window.history.go(-1);
                        //parent.history.back(); //<- use with iFrames
                        return false;

                    });

                $('#ddSchools').change(function () {
                    var $departmentDropdown = $('#ddDepartments');
                    $departmentDropdown.empty();
                    $departmentDropdown.SelectedValue = "";
                });

                $('#<%=ddSchools.ClientID %>').on("change", function () {
                    $('#ctl00_ctl00_contentMain_contentMain_ddDepartments')
                        .append($('<option></option>')
                            .val("Select your subject")
                            .html(""));
                });

                $('#ctl00_ctl00_contentMain_contentMain_ddDepartments')
                    .change(function () {
                        if ($('#ctl00_ctl00_contentMain_contentMain_btnSearch').is(':disabled') === true) {
                            $('#ctl00_ctl00_contentMain_contentMain_btnSearch')
                                .attr("disabled", false)
                                .prop('value', 'SEARCH');
                        }
                    });

                var maxheight = 0;
                $("#ctl00_ctl00_contentMain_contentMain_gvCourses > tbody > tr > td").each(function () {
                    if ($(this).height() > maxheight) {
                        maxheight = $(this).height();
                    }
                });

                $("#ctl00_ctl00_contentMain_contentMain_gvDeltaCourses > tbody > tr > td").each(function () {
                    if ($(this).height() > maxheight) {
                        maxheight = $(this).height();
                    }
                });

                $("table > tbody > tr > td").height(maxheight);

                var h1HeightDbGrid = $("#ctl00_ctl00_contentMain_contentMain_dbGrid > div.dbGrid-transferCourses > h1").height();
                $("#ctl00_ctl00_contentMain_contentMain_dbGrid > div.dbGrid-deltaCourses > h1").height(h1HeightDbGrid);
            });

            $('#ctl00_ctl00_contentMain_contentMain_ddDepartments')
                .change(function () {
                    if ($('#ctl00_ctl00_contentMain_contentMain_btnSearch').is(':disabled') === true) {
                        $('#ctl00_ctl00_contentMain_contentMain_btnSearch')
                            .attr("disabled", false)
                            .prop('value', 'SEARCH');
                    }
                });

            //$("#ctl00_ctl00_contentMain_contentMain_pnlCourses > div.dbGrid-transferCourses.myraidpro > h1").height(newheight);
        </script>

        <%-- <asp:Button CssClass="btnSearch green" ID="btnSearch" Text="SEARCH" OnClick="btnSearch_Click" runat="server" />--%>
    </div>
    <script>

        var noCaps = ['of', 'a', 'the', 'and', 'an', 'am', 'or', 'nor', 'but', 'is', 'if', 'then', 'else', 'when', 'at', 'from', 'by', 'on', 'off', 'for', 'in', 'out', 'to', 'into', 'with'];

        //$(document)
        //    .ready(function () {
        //        $(document)
        //            .ready(function () {

        //$("#ctl00_ctl00_contentMain_contentMain_ddSchools > option").each(function () {
        //    return this.toTitleCase();
        //});

        ////To Camel Case
        //String.prototype.toCamel = function(){
        //    return this.replace(/(\-[a-z])/g, function($1){return $1.toUpperCase().replace('-','');});
        //};

        //String.prototype.toTitleCase = function () {
        //    var smallWords =
        //        /^(a|an|and|as|at|but|by|en|for|if|in|nor|of|on|or|per|the|to|vs?\.?|via)$/i;

        //    return this.replace(/[A-Za-z0-9\u00C0-\u00FF]+[^\s-]*/g,
        //        function (match, index, title) {
        //            if (index > 0 &&
        //                index + match.length !== title.length &&
        //                match.search(smallWords) > -1 &&
        //                title.charAt(index - 2) !== ":" &&
        //                (title.charAt(index + match.length) !== '-' ||
        //                    title.charAt(index - 1) === '-') &&
        //                title.charAt(index - 1).search(/[^\s-]/) < 0) {
        //                return match.toLowerCase();
        //            }

        //            if (match.substr(1).search(/[A-Z]|\../) > -1) {
        //                return match;
        //            }

        //            return match.charAt(0).toUpperCase() + match.substr(1);
        //        });
        //};
        //        });
        //});

        //$(document)
        //    .ready(function () {

        //        $("#ctl00_ctl00_contentMain_contentMain_ddSchools > option").each(function() {
        //            return this.val().toLowerCase();
        //            //return this.replace(/(\-[a-z])/g,
        //            //    function($1) {
        //            //        if (noCaps.indexOf(this.txt.toLowerCase()) !== -1) {
        //            //            return $1.toUpperCase();
        //            //        }
        //            //    });
        //        });
        //// String Functions for Javascript

        ////Trim String
        //String.prototype.trim = function(){
        //    return this.replace(/^\s+|\s+$/g, "");
        //};

        ////To Camel Case
        //String.prototype.toCamel = function(){
        //    return this.replace(/(\-[a-z])/g, function($1){return $1.toUpperCase().replace('-','');});
        //};

        ////To Dashed from Camel Case
        //String.prototype.toDash = function(){
        //    return this.replace(/([A-Z])/g, function($1){return "-"+$1.toLowerCase();});
        //};

        ////To Underscore from Camel Case
        //String.prototype.toUnderscore = function(){
        //    return this.replace(/([A-Z])/g, function($1){return "_"+$1.toLowerCase();});
        //};
    </script>

    <div class="indent" style="display: inline-flex; display: -webkit-inline-flex">
        <asp:UpdatePanel ID="pnlCourses" runat="server">
            <ContentTemplate>
                <div id="dbGrid" class="dbGrid" runat="server" style="text-align: center;">

                    <div class="dbGrid-transferCourses" style="display: inline-block; vertical-align: top;">
                        <h1 class="myriadProBold" style="letter-spacing: .1rem !important; height: auto;">
                            <asp:Literal ID="litSchoolName" runat="server"></asp:Literal>
                        </h1>
                        <br />

                        <asp:GridView ID="gvCourses" AllowSorting="True" AutoGenerateColumns="False" runat="server">
                            <Columns>
                                <asp:TemplateField HeaderText="Course Number">
                                    <ItemTemplate><%#GetTransferCourseNumbers(Eval("LineItemID")) %></ItemTemplate>
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Course Name">
                                    <ItemTemplate><%#GetTransferCourseNames(Eval("LineItemID")) %></ItemTemplate>
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:TemplateField>

                                <asp:BoundField DataField="TransferCredits" HeaderText="Credit Hours" ReadOnly="True">
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <div class="dbGrid-deltaCourses" style="display: inline-block; vertical-align: top;">
                        <h1 class="myriadProBold" style="letter-spacing: .1rem !important;">
                            <asp:Literal ID="litDeltaName" runat="server"></asp:Literal>
                        </h1>
                        <br />

                        <asp:GridView ID="gvDeltaCourses" AllowSorting="False" AutoGenerateColumns="False" runat="server" BorderWidth="0px">
                            <Columns>

                                <asp:TemplateField HeaderText="Course Number">
                                    <ItemTemplate><%#GetDeltaCourseNumbers(Eval("LineItemID")) %></ItemTemplate>
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Course Name">
                                    <ItemTemplate><%#GetDeltaCourseNames(Eval("LineItemID")) %></ItemTemplate>
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:TemplateField>

                                <asp:BoundField DataField="DeltaCredits" HeaderText="Credit Hours" SortExpression="DeltaCredits">
                                    <ItemStyle Width="45em" CssClass="gridViewCSS" Font-Size="10pt" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <asp:SqlDataSource
                    ID="SqlDataSourceCourseMap"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:TranEquivConnectionString %>"
                    SelectCommand="SELECT * FROM [LineItems] WHERE (([SchoolID] = @SchoolID) AND ([DepartmentID] = @DepartmentID))">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="SchoolID" QueryStringField="SchoolID" Type="String" />
                        <asp:ControlParameter ControlID="ddDepartments" Name="DepartmentID" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div style="min-height: 20px !important; max-height: 20px !important; clear: both;"></div>
    <div class="footer">
        <p>Delta College | 1961 Delta Road, University Center, MI 48710 | 989-686-9000</p>
    </div>

    <%--resolveURL solves problem with js in master pages--%>
    <script type="text/javascript" src='<%
        var resolveUrl = ResolveUrl("Scripts/jquery-3.1.1.min.js");
		%>'>
    </script>
    <script src="Scripts/bootstrap.min.js"></script>
</asp:Content>