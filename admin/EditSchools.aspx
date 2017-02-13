<%@ Page Language="C#" MasterPageFile="~/MasterPages/Default.master" Theme="Default" AutoEventWireup="true" CodeFile="EditSchools.aspx.cs" Inherits="admin_EditSchools" Title="Untitled Page" %>

<%@ OutputCache NoStore="true" Duration="1" VaryByParam="none" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <h1>Edit Schools</h1>

    <div id="alphabet" style="margin-top: 10px;">
        <sungard:Alphabet runat="server" SelectedCharacter="A" FillLastRow="true" ID="Alphabet1"
            IncludeAll="false" IncludeNumbers="false" Rows="1" TableCssClass="table" ItemCssClass="cell"
            ItemSelectedCssClass="selected" ItemUnavailableCssClass="unavailable"
            OnSelectedCharacterChanged="Alphabet1_SelectedCharacterChanged" />
    </div>

    <div style="margin-top: 10px;" id="schools">
        <sungard:GridView ID="gvSchools" SkinID="GridView" runat="server" AllowSorting="True" AutoGenerateColumns="False"
            DataKeyNames="SchoolID" DataSourceID="LinqDataSourceSchools">
            <Columns>
                <asp:BoundField DataField="SchoolName" HeaderText="School Name" SortExpression="SchoolName" ItemStyle-CssClass="SchoolName" />
                <asp:BoundField DataField="Website" HeaderText="Website" SortExpression="Website" ItemStyle-CssClass="Website" />
                <asp:CommandField ShowEditButton="True" />
            </Columns>
        </sungard:GridView>
        <asp:LinqDataSource ID="LinqDataSourceSchools" runat="server" ContextTypeName="TranEquivDataContext"
            EnableUpdate="True" OrderBy="SchoolName" OnSelecting="LinqDataSourceSchools_Selecting" TableName="Schools">
        </asp:LinqDataSource>
    </div>
</asp:Content>