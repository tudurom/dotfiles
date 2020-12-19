#!/usr/bin/env nix-shell
#! nix-shell -i python -p python38 python38Packages.pygments python38Packages.markdown

# This script uses Pygments and Python3. You must have both installed
# for this to work.
#
# http://pygments.org/
# http://python.org/
#
# It may be used with the source-filter or repo.source-filter settings
# in cgitrc.
#
# The following environment variables can be used to retrieve the
# configuration of the repository for which this script is called:
# CGIT_REPO_URL        ( = repo.url       setting )
# CGIT_REPO_NAME       ( = repo.name      setting )
# CGIT_REPO_PATH       ( = repo.path      setting )
# CGIT_REPO_OWNER      ( = repo.owner     setting )
# CGIT_REPO_DEFBRANCH  ( = repo.defbranch setting )
# CGIT_REPO_SECTION    ( = section        setting )
# CGIT_REPO_CLONE_URL  ( = repo.clone-url setting )


import sys
import io
import types
import markdown
from pygments import highlight
from pygments.util import ClassNotFound
from pygments.lexers import TextLexer
from pygments.lexers import MarkdownLexer
from pygments.lexers import guess_lexer
from pygments.lexers import guess_lexer_for_filename
from pygments.formatters import HtmlFormatter


sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
data = sys.stdin.read()
filename = sys.argv[1]
formatter = HtmlFormatter(style='pastie')

try:
	lexer = guess_lexer_for_filename(filename, data)
except ClassNotFound:
	# check if there is any shebang
	if data[0:2] == '#!':
		try:
			lexer = guess_lexer(data)
		except ClassNotFound:
			lexer = TextLexer()
	else:
		lexer = TextLexer()
except TypeError:
	lexer = TextLexer()

if isinstance(lexer, MarkdownLexer):
        # based on html-converters/md2html
        sys.stdout.write('''
<!-- close the stuff we want to hide anyway -->
</code></pre></td></tr></table>
<style>
.blob { display: none }
.markdown-body {
    font-size: 14px;
    line-height: 1.6;
    margin-top: 20px;
    overflow: hidden;
}
.markdown-body>*:first-child {
    margin-top: 0 !important;
}
.markdown-body>*:last-child {
    margin-bottom: 0 !important;
}
.markdown-body a.absent {
    color: #c00;
}
.markdown-body a.anchor {
    display: block;
    padding-left: 30px;
    margin-left: -30px;
    cursor: pointer;
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
}
.markdown-body h1, .markdown-body h2, .markdown-body h3, .markdown-body h4, .markdown-body h5, .markdown-body h6 {
    margin: 20px 0 10px;
    padding: 0;
    font-weight: bold;
    -webkit-font-smoothing: antialiased;
    cursor: text;
    position: relative;
}
.markdown-body h1 .mini-icon-link, .markdown-body h2 .mini-icon-link, .markdown-body h3 .mini-icon-link, .markdown-body h4 .mini-icon-link, .markdown-body h5 .mini-icon-link, .markdown-body h6 .mini-icon-link {
    display: none;
    color: #000;
}
.markdown-body h1:hover a.anchor, .markdown-body h2:hover a.anchor, .markdown-body h3:hover a.anchor, .markdown-body h4:hover a.anchor, .markdown-body h5:hover a.anchor, .markdown-body h6:hover a.anchor {
    text-decoration: none;
    line-height: 1;
    padding-left: 0;
    margin-left: -22px;
    top: 15%}
.markdown-body h1:hover a.anchor .mini-icon-link, .markdown-body h2:hover a.anchor .mini-icon-link, .markdown-body h3:hover a.anchor .mini-icon-link, .markdown-body h4:hover a.anchor .mini-icon-link, .markdown-body h5:hover a.anchor .mini-icon-link, .markdown-body h6:hover a.anchor .mini-icon-link {
    display: inline-block;
}
.markdown-body h1 tt, .markdown-body h1 code, .markdown-body h2 tt, .markdown-body h2 code, .markdown-body h3 tt, .markdown-body h3 code, .markdown-body h4 tt, .markdown-body h4 code, .markdown-body h5 tt, .markdown-body h5 code, .markdown-body h6 tt, .markdown-body h6 code {
    font-size: inherit;
}
.markdown-body h1 {
    font-size: 28px;
    color: #000;
}
.markdown-body h2 {
    font-size: 24px;
    border-bottom: 1px solid #ccc;
    color: #000;
}
.markdown-body h3 {
    font-size: 18px;
}
.markdown-body h4 {
    font-size: 16px;
}
.markdown-body h5 {
    font-size: 14px;
}
.markdown-body h6 {
    color: #777;
    font-size: 14px;
}
.markdown-body p, .markdown-body blockquote, .markdown-body ul, .markdown-body ol, .markdown-body dl, .markdown-body table, .markdown-body pre {
    margin: 15px 0;
}
.markdown-body hr {
    background: transparent url("/dirty-shade.png") repeat-x 0 0;
    border: 0 none;
    color: #ccc;
    height: 4px;
    padding: 0;
}
.markdown-body>h2:first-child, .markdown-body>h1:first-child, .markdown-body>h1:first-child+h2, .markdown-body>h3:first-child, .markdown-body>h4:first-child, .markdown-body>h5:first-child, .markdown-body>h6:first-child {
    margin-top: 0;
    padding-top: 0;
}
.markdown-body a:first-child h1, .markdown-body a:first-child h2, .markdown-body a:first-child h3, .markdown-body a:first-child h4, .markdown-body a:first-child h5, .markdown-body a:first-child h6 {
    margin-top: 0;
    padding-top: 0;
}
.markdown-body h1+p, .markdown-body h2+p, .markdown-body h3+p, .markdown-body h4+p, .markdown-body h5+p, .markdown-body h6+p {
    margin-top: 0;
}
.markdown-body li p.first {
    display: inline-block;
}
.markdown-body ul, .markdown-body ol {
    padding-left: 30px;
}
.markdown-body ul.no-list, .markdown-body ol.no-list {
    list-style-type: none;
    padding: 0;
}
.markdown-body ul li>:first-child, .markdown-body ul li ul:first-of-type, .markdown-body ul li ol:first-of-type, .markdown-body ol li>:first-child, .markdown-body ol li ul:first-of-type, .markdown-body ol li ol:first-of-type {
    margin-top: 0px;
}
.markdown-body ul li p:last-of-type, .markdown-body ol li p:last-of-type {
    margin-bottom: 0;
}
.markdown-body ul ul, .markdown-body ul ol, .markdown-body ol ol, .markdown-body ol ul {
    margin-bottom: 0;
}
.markdown-body dl {
    padding: 0;
}
.markdown-body dl dt {
    font-size: 14px;
    font-weight: bold;
    font-style: italic;
    padding: 0;
    margin: 15px 0 5px;
}
.markdown-body dl dt:first-child {
    padding: 0;
}
.markdown-body dl dt>:first-child {
    margin-top: 0px;
}
.markdown-body dl dt>:last-child {
    margin-bottom: 0px;
}
.markdown-body dl dd {
    margin: 0 0 15px;
    padding: 0 15px;
}
.markdown-body dl dd>:first-child {
    margin-top: 0px;
}
.markdown-body dl dd>:last-child {
    margin-bottom: 0px;
}
.markdown-body blockquote {
    border-left: 4px solid #DDD;
    padding: 0 15px;
    color: #777;
}
.markdown-body blockquote>:first-child {
    margin-top: 0px;
}
.markdown-body blockquote>:last-child {
    margin-bottom: 0px;
}
.markdown-body table th {
    font-weight: bold;
}
.markdown-body table th, .markdown-body table td {
    border: 1px solid #ccc;
    padding: 6px 13px;
}
.markdown-body table tr {
    border-top: 1px solid #ccc;
    background-color: #fff;
}
.markdown-body table tr:nth-child(2n) {
    background-color: #f8f8f8;
}
.markdown-body img {
    max-width: 100%;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}
.markdown-body span.frame {
    display: block;
    overflow: hidden;
}
.markdown-body span.frame>span {
    border: 1px solid #ddd;
    display: block;
    float: left;
    overflow: hidden;
    margin: 13px 0 0;
    padding: 7px;
    width: auto;
}
.markdown-body span.frame span img {
    display: block;
    float: left;
}
.markdown-body span.frame span span {
    clear: both;
    color: #333;
    display: block;
    padding: 5px 0 0;
}
.markdown-body span.align-center {
    display: block;
    overflow: hidden;
    clear: both;
}
.markdown-body span.align-center>span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: center;
}
.markdown-body span.align-center span img {
    margin: 0 auto;
    text-align: center;
}
.markdown-body span.align-right {
    display: block;
    overflow: hidden;
    clear: both;
}
.markdown-body span.align-right>span {
    display: block;
    overflow: hidden;
    margin: 13px 0 0;
    text-align: right;
}
.markdown-body span.align-right span img {
    margin: 0;
    text-align: right;
}
.markdown-body span.float-left {
    display: block;
    margin-right: 13px;
    overflow: hidden;
    float: left;
}
.markdown-body span.float-left span {
    margin: 13px 0 0;
}
.markdown-body span.float-right {
    display: block;
    margin-left: 13px;
    overflow: hidden;
    float: right;
}
.markdown-body span.float-right>span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: right;
}
.markdown-body code, .markdown-body tt {
    margin: 0 2px;
    padding: 0px 5px;
    border: 1px solid #eaeaea;
    background-color: #f8f8f8;
    border-radius: 3px;
}
.markdown-body code {
    white-space: nowrap;
}
.markdown-body pre>code {
    margin: 0;
    padding: 0;
    white-space: pre;
    border: none;
    background: transparent;
}
.markdown-body .highlight pre, .markdown-body pre {
    background-color: #f8f8f8;
    border: 1px solid #ccc;
    font-size: 13px;
    line-height: 19px;
    overflow: auto;
    padding: 6px 10px;
    border-radius: 3px;
}
.markdown-body pre code, .markdown-body pre tt {
    margin: 0;
    padding: 0;
    background-color: transparent;
    border: none;
}
''')
        sys.stdout.write(HtmlFormatter(style='pastie').get_style_defs('.highlight'))
        sys.stdout.write('''
        </style>
        ''')
        sys.stdout.write("<div class='markdown-body' id='top'>")
        sys.stdout.flush()
        # Note: you may want to run this through bleach for sanitization
        html = markdown.markdown(
                data,
                output_format="html5",
                extensions=[
                        "markdown.extensions.fenced_code",
                        "markdown.extensions.codehilite",
                        "markdown.extensions.tables",
                        "markdown.extensions.toc"],
                extension_configs={
                        "markdown.extensions.codehilite":{"css_class":"highlight"}})
        sys.stdout.write(html)
        sys.stdout.write("</div>")
        # add back the useless tags (and this table will be hidden just like the first one)
        sys.stdout.write("<table class='blob'><tr><td><pre><code>")
else:
        # printout pygments' css definitions as well
        sys.stdout.write('<style>')
        sys.stdout.write(formatter.get_style_defs('.highlight'))
        sys.stdout.write('</style>')
        sys.stdout.write(highlight(data, lexer, formatter, outfile=None))
