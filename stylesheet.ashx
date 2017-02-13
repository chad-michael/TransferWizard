<%@ WebHandler Language="C#" Class="stylesheet" %>

using System;
using System.IO;
using System.Web;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Caching;
using System.IO.Compression;

public class stylesheet : IHttpHandler {

    public bool IsReusable {
        get { return false; }
    }

    public void ProcessRequest(HttpContext context) {
        string key = context.Request.QueryString["stylesheets"];
        StringBuilder css = new StringBuilder();
        string[] relativeFiles = context.Request.QueryString["stylesheets"].Split(',');
        string[] absoluteFiles = new string[relativeFiles.Length];
        if (!string.IsNullOrEmpty(context.Request.QueryString["stylesheets"])) {
            if (context.Cache[key] == null) {
                
                for (int i = 0; i < relativeFiles.Length; i++) {
                    string file = relativeFiles[i];
                    if (file.EndsWith(".css")) {
                        string absoluteFile = context.Server.MapPath(file);
                        using (StreamReader reader = new StreamReader(absoluteFile)) {
                            css.Append(StripWhitespace(reader.ReadToEnd()));
                        }
                        absoluteFiles[i] = absoluteFile;
                    }
                }
                context.Cache.Insert(key, css.ToString(), new CacheDependency(absoluteFiles), Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration);
            }
            string content = (string)context.Cache[key];
            if (!string.IsNullOrEmpty(content)) {
                context.Response.Write(content);
                SetHeaders(context, absoluteFiles);
                Compress(context);
            }
        }
    }

    /// <summary>
    /// Strips the whitespace from any .css file.
    /// </summary>
    private static string StripWhitespace(string body) {
        body = body.Replace("  ", String.Empty);
        body = body.Replace(Environment.NewLine, String.Empty);
        body = body.Replace("\t", string.Empty);
        body = body.Replace(" {", "{");
        body = body.Replace(" :", ":");
        body = body.Replace(": ", ":");
        body = body.Replace(", ", ",");
        body = body.Replace("; ", ";");
        body = body.Replace(";}", "}");
        body = Regex.Replace(body, @"(?<=[>])\s{2,}(?=[<])|(?<=[>])\s{2,}(?=&nbsp;)|(?<=&ndsp;)\s{2,}(?=[<])", String.Empty);
        // This line can cause trouble on some stylesheets. It removes comments.
        //body = Regex.Replace(body, @"/\*[^\*]*\*+([^/\*]*\*+)*/", "$1");
        body = RemoveCommentBlocks(body);
        return body;
    }
    private static string RemoveCommentBlocks(string input) {
        int startIndex = 0;
        int endIndex = 0;
        bool iemac = false;
        startIndex = input.IndexOf(@"/*", startIndex);
        while (startIndex >= 0) {
            endIndex = input.IndexOf(@"*/", startIndex + 2);
            if (endIndex >= startIndex + 2) {
                if (input[endIndex - 1] == '\\') {
                    startIndex = endIndex + 2;
                    iemac = true;
                } else if (iemac) {
                    startIndex = endIndex + 2;
                    iemac = false;
                } else {
                    input = input.Remove(startIndex, endIndex + 2 - startIndex);
                }
            }
            startIndex = input.IndexOf(@"/*", startIndex);
        }
        return input;
    }

    /// <summary>
    /// This will make the browser and server keep the output
    /// in its cache and thereby improve performance.
    /// </summary>
    private static void SetHeaders(HttpContext context, string[] files) {
        context.Response.ContentType = "text/css";
        context.Response.Cache.VaryByHeaders["Accept-Encoding"] = true;

        context.Response.Cache.SetExpires(DateTime.Now.ToUniversalTime().AddDays(30));
        context.Response.Cache.SetCacheability(HttpCacheability.Public);
        context.Response.Cache.SetMaxAge(new TimeSpan(30, 0, 0, 0));
        context.Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
        context.Response.Cache.SetETag("\"" + context.GetHashCode().ToString() + "\"");
    }
    
    #region Compression

    private const string GZIP = "gzip";
    private const string DEFLATE = "deflate";

    private static void Compress(HttpContext context) {
        if (context.Request.UserAgent != null && context.Request.UserAgent.Contains("MSIE 6"))
            return;

        if (IsEncodingAccepted(GZIP)) {
            context.Response.Filter = new GZipStream(context.Response.Filter, CompressionMode.Compress);
            SetEncoding(GZIP);
        } else if (IsEncodingAccepted(DEFLATE)) {
            context.Response.Filter = new DeflateStream(context.Response.Filter, CompressionMode.Compress);
            SetEncoding(DEFLATE);
        }
    }

    /// <summary>
    /// Checks the request headers to see if the specified
    /// encoding is accepted by the client.
    /// </summary>
    private static bool IsEncodingAccepted(string encoding) {
        return HttpContext.Current.Request.Headers["Accept-encoding"] != null && HttpContext.Current.Request.Headers["Accept-encoding"].Contains(encoding);
    }

    /// <summary>
    /// Adds the specified encoding to the response headers.
    /// </summary>
    /// <param name="encoding"></param>
    private static void SetEncoding(string encoding) {
        HttpContext.Current.Response.AppendHeader("Content-encoding", encoding);
    }

    #endregion

}