﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderWrapper.ascx.cs"
    Inherits="Controls_HeaderWrapper" %>
<%@ Register Src="SearchArea.ascx" TagName="SearchArea" TagPrefix="sungard" %>
<h1 id="mainlogo" title="mainlogo">
    <a href="http://www.delta.edu/home.aspx" title="Delta College Home"><a href="http://www.delta.edu/home.aspx" title="Delta College Home"><img src="/images/system/redesign/DeltaLogo.png" title="Delta College Home" alt="Delta College logo" /></a></h1>
<div id="header_toplinks">
    <a href="http://www.delta.edu/pages/125.aspx" title="About Delta">About Delta</a> | <a href="http://www.delta.edu/humres" title="Jobs at Delta">Jobs at Delta</a> | <a href="http://www.delta.edu/internal/atoz.aspx"
        title="A-Z Index">A-Z Index</a> | <a href="https://portal.delta.edu" title="Portal">Portal</a> | <a href="https://my.delta.edu" title="MyDelta">MyDelta</a> | <a href="http://apps.delta.edu/peoplefinder/viewdepartment.aspx?departmentname=delta"
                title="Contact Us">Contact Us</a>
</div>

<div id="searcharea">
    <sungard:SearchArea ID="SearchArea1" runat="server" />
</div>
