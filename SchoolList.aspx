<%@ Page Language="C#" MasterPageFile="~/MasterPages/AppCustom.master" AutoEventWireup="true" CodeFile="SchoolList.aspx.cs" Inherits="SchoolList" Title="Transfer Wizard" %>

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

    <div style="margin: 10px 0;">
        Select a school from which you want to get more information about transfer credits. Schools that are highlighted in yellow indicate a link to the equivalency page provided by that College or University.
    </div>

    <div id="alphabet">
        <sungard:Alphabet runat="server" SelectedCharacter="%" AvailableLetters="" FillLastRow="true" ID="Alphabet1"
            IncludeAll="true" IncludeNumbers="false" Rows="2" TableCssClass="table" ItemCssClass="cell"
            ItemSelectedCssClass="selected" ItemUnavailableCssClass="unavailable"
            OnSelectedCharacterChanged="Alphabet1_SelectedCharacterChanged" />
    </div>

    <div>
        <asp:Repeater ID="rptSchools" runat="server">
            <HeaderTemplate>
                <ul id="schools">
            </HeaderTemplate>
            <ItemTemplate>
                <li class="<%#Highlight(Eval("Website")) %>">
                    <asp:HyperLink
                        ID="lnkSchool"
                        NavigateUrl='<%#Eval("SchoolID", "SchoolMenu.aspx?SchoolID={0}") %>'
                        runat="server"><%#Eval("SchoolName") %>
                    </asp:HyperLink>
                </li>
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>