![Tclssg](./logo/tclssg-logo-text-small.png)

Tclssg is a static site generator with template support written in Tcl for danyilbohdan.com. It is intended to make it easy to manage a small to medium-sized personal website with an optional blog, "small to medium-sized" meaning one with under about 2000 pages. Tclssg uses Markdown for content formatting, [Bootstrap](http://getbootstrap.com/) for layout (with Bootstrap theme support) and Tcl code embedded in HTML for templating.

**Warning! Tclssg is currently in beta and may still change in incompatible ways.**

Features
--------

* [Markdown](#markup), Bootstrap themes, Tcl code for [templates](#templating);
* Plain old pages and blog posts [1];
* RSS feeds;
* SEO and usability features: sitemaps, canonical and previous/next links, noindex on collection pages.
* Valid HTML5 and CSS level 3 output;
* Deployment over FTP;
* Deployment over SCP or other protocols with a [custom deployment command](#using-deploycustom);
* Support for external comment engines (currently: Disqus);
* Relative links in the HTML output that make it suitable for viewing over file://;
* [Reasonably fast](https://github.com/dbohdan/tclssg/wiki/Performance);
* Few dependencies.

1\. A blog post differs from a plain old page in that it has a sidebar with links to other blog posts sorted by recency and tags. The latest blog posts are featured on the blog index and tag pages are generated to collect blog posts with the same tag.

Page screenshot
---------------
![A test page generated by Tclssg](screenshot.png)

Getting started
---------------

Tclssg is known to run on Linux, FreeBSD, OpenBSD, NetBSD, OS X and Windows XP/7/8.x.

To use it you will need Tcl 8.5 or newer, Tcllib and SQLite version 3 bindings for Tcl installed.

To install those on **Debian** or **Ubuntu** run the following command:

    sudo apt-get install tcl tcllib libsqlite3-tcl

On **Fedora**, **RHEL** or **CentOS**:

    su -
    yum install tcl tcllib sqlite-tcl

On **Windows** the easiest option is to install ActiveTcl from [ActiveState](http://activestate.com/). The copy of Tcl that comes with [Git for Windows](http://msysgit.github.io/) does not include Tcllib or an SQLite 3 module, so it will not run Tclssg out of the box.

Once you have the dependencies installed clone this repository, `cd` into it then run

    chmod +x ssg.tcl
    ./ssg.tcl init
    ./ssg.tcl build
    ./ssg.tcl open

or on Windows

    ssg.cmd init
    ssg.cmd build
    ssg.cmd open

This will create a new website project in the directory `website/input` based on the default project skeleton, build the website in `website/output` and open the result in your web browser.

Glossary
--------

| Term | Explanation |
|---------|-------------|
| Page | The main building block of your static website. A page is a file with the extension `.md` and Markdown content. When a typical page from the input directory is processed by Tclssg an HTML file is placed under the same relative path in the output directory with the same file name. For example, placing the page `test/page1.md` in `inputDir`  will generate the HTML file `test/page1.html` in `outputDir`. A page can be a blog post (see below) or not. |
| Blog post | Blog posts are pages with special properties that help navigate a typical blog: tags for categorization and a sidebar with links to other blog posts. Blog posts are presented in a chronological order (based on their the `date` settings) on the blog index page. The order in which the links to blog posts appear on the sidebar is also determined by the posts' dates. The sidebar, tags and other features can be selectively disabled for any individual blog post or for all of them by default. |
| Index | The home page of your website. Typically `index.md` in `inputDir`. |
| Blog index | The blog index is a page or a set of pages that present all of your blog posts in the order from the latest to the oldest. The website setting `blogIndex` (normally typically set to `blog/index.md`) determines what page is used as the basis for the blog index. To avoid producing overly long webpages and HTML files that are too large the blog index page will be broken into separate HTML files according the website setting `blogPostsPerFile` (see section ["Website settings"](#website-settings)). |
| Tag page | A tag page is a page that shows all blog posts that have a certain tag in a chronological order. When you build your static website a tag page is created for each tag. Like the blog index a tag page will be broken into separate HTML files according the website setting `blogPostsPerFile`. The website setting `tagPage` (normally set to `blog/tag.md`) determines what page is used as the basis for tag pages. If you have a tag `space` then the content of `blog/tag.md` will be copied to `blog/tag-space.md`  |
| Article | The Markdown content of a page transformed into HTML and placed between the tags `<article>...</article>`.  |
| Document | A single output file that is an HTML or XML document (the latter in the case of RSS). May include one or more articles: one for regular pages and blog posts, more on the blog index page and on tag pages. |
| Collection | A document that contains more than one article, i.e., the blog index or a tag pages. |
| Template | A file with Tcl code embedded in HTML markup. Once a page has been converted from Markdown to HTML its content is rendered according to the template's logic (code), which interprets the settings specified in the page file and the website config file. Tclssg's templating works in two stages: first, input pages are processed into [HTML5 articles](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/article) (delimited by the tags `<article>...</article>`) using the article template (`article.thtml` by default) then one or several articles are inserted into the document template (`bootstrap.thtml`), one for normal pages and blog posts and several for the blog index. |
| Configuration file | The file `website.conf` in the input directory that specifies the settings that apply to the static website as a whole like the website title. |
| Setting | In Tclssg a settings specifies one option for either the whole website or an individual page. Those range from the page title, which you'd normally want to set for each page, to the password for the FTP server your want to deploy your website to. When a setting is set in a page file it specifies the corresponding setting for just that individual page. When a setting is set the configuration ("config") file it specifies a setting for the website as a whole. |
| Static file | A file that should be copied verbatim into to the output directory. Those are stored in a subdirectory of the input directory (`inputDir/static`). File paths relative to `inputDir/static` are preserved, which means that, e.g., `website/input/static/blah/file.zip` will be copied to `website/output/blah/file.zip`.  |
| Project skeleton | A starting point for Tclssg websites contained in the `skeleton` directory. |
| Output | The static website ready to be deployed. Consists of HTML files created by Tclssg based on the content in the input directory plus the static files. It is placed in the output directory `outputDir`. |

Usage
-----

    usage: ./ssg.tcl <command> [options] [inputDir [outputDir]]

`inputDir` specifies the directory where the input for Tclssg is located. It defaults to `website/input` in the current directory.
`outputDir` is where the static website's files are placed when the output is generated. When neither `inputDir` nor `outputDir` is supplied on the command line `outputDir` defaults to `website/output`; if `inputDir` is supplied but not `outputDir` then Tclssg will use the value of the setting `outputDir` in the configuration file `inputDir/website.conf`.

Possible commands are

* `init [--templates]` — сreate a new website project from the default project skeleton.

> The option `--templates` will make `init` copy the template files from the project skeleton into a subdirectory named `templates` in `inputDir`. You should only use it if you intend to customize your page's layout (HTML code); it is not necessary if you only intend to customize the websites' look using CSS (including Bootstrap themes).

>By default your project will directly use the page template of the project skeleton. Not keeping a separate copy of the template is a good idea because it means you won't have to update it manually when a new version of Tclssg introduces changes to templating (which at this point in development it may).

* `build` — build a static website in `outputDir` based on the data in `inputDir`.
* `clean` — delete all files in `outputDir`.
* `update [--templates] [--yes]` — replace static files in `inputDir` that have matching ones in the project skeleton with those in the project skeleton. Do the same with templates if the option `--templates` is given. Tclssg will prompt you whether to replace each file unless you specify the option `--yes`. This is used to update your website project when Tclssg itself is updated.
* `deploy-copy` — copy files to the destination set in the configuration file (`website.conf`). This can be used if your build machine is your web server or if you have the server's documents directory mounted as a local path.
* `deploy-custom` — execute a custom deploy command.
* `deploy-ftp` — deploy files to the FTP server according to the FTP settings in the configuration file.
* `open` — open the index page in the default browser.

The default layout of the input directory is as follows:

    .
    ├── pages <-- Markdown files from which HTML is generated.
    │   ├── blog <-- Blog posts.
    │   │   └── index.md <-- Blog index page with the tag list and blog posts
    │   │                    in a chronological order.
    │   └── index.md <-- Website index page.
    ├── static <-- Files copied verbatim to the output directory.
    │   └── images <-- The default location for image files.
    ├── templates <-- The website's layout templates (HTML + Tcl).
    │   ├── common.tcl
    │   ├── ...
    │   ├── article.thtml
    │   └── bootstrap.thtml
    └── website.conf <-- The configuration file.

Once you've initialized your website project with `init` you can customize it by specifying general and per-page settings. Specify its general settings in `website.conf` and the per-page settings in the individual page files. Those are two different categories of settings but defaults for page settings can be set in `website.conf` (look for `pageSettings` below).

Markup
------

Write [Markdown](http://daringfireball.net/projects/markdown/syntax) and use `<!-- more -->` to designate the break between the teaser (the part of the article shown on the blog index and on tag pages) and the rest of the content. Use page settings to customize the page's output. Example:

```markdown
{
    title {Test page}
    blogPost 1
    tags {test {a long tag with spaces}}
    date 2014-01-02
    hideDate 1
}
**Lorem ipsum** reprehenderit _ullamco deserunt sit eiusmod_ ut minim in id
voluptate proident enim eu aliqua sit.

<!-- more -->

Mollit ex cillum pariatur anim [exemplum](http://example.com) tempor
exercitation sed eu Excepteur dolore deserunt cupidatat aliquip irure in
fugiat eu laborum est.
```

Templating
----------

Templating involves including one of the following constructs in your markup. You can use templates in HTML in templates or in Markdown in page files when `expandMacrosInPages` is enabled.

### 1. `<% raw code %>`

Wraps code around content. This is typically used for loops.

#### Examples
##### In template files (HTML)

    <ul>
    <% foreach city $cities { %>
        <li><%= $city %></li>
    <% } %>
    </ul>

##### In a page file (Markdown)

Using this requires setting `expandMacrosInPages` to `1` in `website.conf`.

    <% foreach city $cities { %>
    * <%= $city %>
    <% } %>

### 2. `<%= expression>`

Inserts the value of an expression (including an expression consisting of just a single variable like `$city`) in the output.

#### Examples

* `<%= $content %>`

* `<%= 1 + 2 %>`

### 3. `<%! command %>`.

Inserts the return value of a single command in the output.

#### Examples

* `<title><%! format-html-title %></title>`

### Page template example: responsive images with Bootstrap

This subsection describes template commands included with Tclssg that are intended for use in page files. They solve the problem of responsive images being awkward to include in Markdown and show how page template commands can be useful.

The problem is as follows: Bootstrap allows you to make images responsive (automatically and proportionally scaled to the width of your page) and centered (if they are not wide enough to fill the entire page width) by giving them appropriate classes through the `class` attribute, however, Markdown doesn't allow you to specify the `class` attribute of an image. You could do it manually with HTML markup like

    <img src="../images/picture.png" class="img-responsive center-block" alt="Alt text">

but with many images it introduces unnecessary repetition and you have to put in the image path manually. The following macros allow you to include responsive images in a page with a concise command.

To use this feature first set `expandMacrosInPages` to `1` and put `<% interp-source img.tcl %>` after the frontmatter in the file where you intend to use responsive images:

    {
        title {Hello!}
    }
    <% interp-source img.tcl %>

Now you can use the command

    <%! img-local picture.png "Alt text" %>`

to include an image from `inputDir/static/images` (`inputDir/static/images/picture.png` in this case). This command generates the same HTML markup as seen above.

You can also use

    <%! img http://example.com/image.png "Alt text" %>

to make images sourced from anywhere responsive.

Page settings
------------------
Page settings are specified using page settings. Each page setting alters a parameter for just the page it is set on. Page settings are set at in the front matter (immediately at the top of a page source file) using Tcl dict syntax. Example:

    {
        variableNameOne short_value
        variableNameTwo {A variable value with spaces.}
    }
    Lorem ipsum... (The rest of the page content follows.)

Values can be quoted with braces (`{value}`) or double quotes (`"value"`). If you want to set a page variable for more than one page at once look at the website setting `pageSettings` in the next section.

The following settings have an effect for **any page** they are set on.

### Basic page information

| Setting name | Example value(s) | Description |
|---------------|------------------|-------------|
| title | `{Some title}` | The title of the individual page. By default it goes in the `<title>` tag and the article header at the top of the page. It is also used as the text for sidebar links to the page. |
| date | `2014`, `2014/06/23`, `2014-06-23`, `2014-06-23 14:35`, `2014-06-23 14:35:01` | Blog posts are sorted on the `date` field. The date must be in an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)-like format of year-month-day-hour-minute-second. Dashes, spaces, colons, slashes, dots and `T` are all treated the same for sorting, so `2014-06-23T14:35:01` is equivalent to `2014 06 23 14 35 01`. |
| `modified` or `modifiedDate` | same as `date` | Used to indicate when the content was last changed since the date in the `date` setting. Not used for sorting. |
| author | `McPerson` | The name of the author or the person responsible for the page. Will be displayed under the title. |
| description | `{This is the main page of my website.}` | The content of the `<meta name="description">` tag. You should **not** set this one to the same value for multiple pages; see Matt Cutts [on the matter](https://www.youtube.com/watch?v=W4gr88oHb-k). |
| `blog` or `blogPost` | 0/1 | If this is set to 1 the page will be a blog post. It will show in the blog post list. |

### Output document

| Setting name | Example value(s) | Description |
|---------------|------------------|-------------|
| navbarBrand | `{}` | Replaces the `websiteTitle` in Bootstrap `.navbar-brand` link if not empty. Understands `$rootDirPath`. |
| navbarItems | `{ Home $indexLink Blog $blogIndexLink Contact {$rootDirPath/contact.html}`  |  The list of items to display in the navbar at the top of the page. The format of the list is `{LinkText LinkHref LinkText LinkHref...}` where LinkHref is treated like an expression inside the template. |
| locale | `en_US` | The page's language. The value of `locale` is used to internationalize small bits of text like "page #5" used in templates. Translations of each message to a given locale can be defined by copying the file `skeleton/templates/messages.tcl` to `templates/messages.tcl` in your `inputDir` and adding the translations there. |
| favicon | `favicon.ico` | [Favicon](https://en.wikipedia.org/wiki/Favicon) filename and path relative to `outputDir`. |
| headExtra | `{<link rel="stylesheet" href="./page-specific.css">}` | HTML to append to `<head>`. |
| bodyExtra | `{<script>[...]</script>">}` | HTML to append to `<body>`. |
| articleExtra | `{}` | HTML to append to `<article>`. |
| pagePrelude | `{<% interp-source img.tcl %>}` | The content (normally macros) to prepend to each page's content before the macro expansion stage if macro expansion is enabled. This is not very useful in the pages themselves and is intended to be set in `pageVariables` or `blogPostVariables`. Example use would be to include `img.tcl` on all pages. Only use this setting if you know what you are doing. |

### Hiding elements

| Setting name | Example value(s) | Description |
|---------------|------------------|-------------|
| draft | 0/1 | Do not process the page. Useful for keeping drafts in the same directory as published pages. |
| hideUserComments | 0/1 | Do not display comments on this current page. |
| hideTitle | 0/1 | Do not put the value of `title` in the `<title>` tag and do not display it at the top of the page. The page title will then only be used for sidebar links to the page. |
| hideArticleTitle | 0/1 | Do not display the value of `title` at the top of the page. |
| hideDate | 0/1 | Do not show the page date or the last modification date. |
| hideModifiedDate | 0/1 | Do not show the last modification date. |
| hideAuthor | 0/1 | Do not show the page author. |
| hideFromCollections | 0/1 | Do not list the page or the blog post in the sitemap. Do not include the content of the blog post in article collections, namely the tag pages and the blog index, as well as sidebar links. |
| sidebarNote | `{<h3>About</h3> This is my blog.}` | The content of the sidebar note in HTML. The note is displayed in a box to the right of the content. On blog posts its content is placed above the sidebar links and the tag cloud. |
| hideSidebarNote | 0/1 | Don't show the sidebar note on the present page. |
| hideFooter | 0/1 | Disable the "Powered by" footer. The copyright notice, if enabled, is still displayed. |

These settings only affect **blog posts**:

| Setting name | Example value(s) | Description |
|---------------|------------------|-------------|
| tags | `{tag1 tag2 {tag three with multiple words} {tag four} tag-five}` | Blog post tags for categorization. Each tag will link to its respective tag page. |
| moreText | `{(<a href="$link">read on</a>)}` | What appears at the end of the teaser (the content before `<!-- more -->`) on the blog index page; `$link` in `moreText` is replaced with a link to the full blog post. moreText is set to `(...)` (without a link to the page) by default. |
| hideFromSidebarLinks | 0/1 | Unlists the post from other posts' sidebar links. Useful for post drafts you may want to share with others through a direct link but don't want any reader of your blog to see otherwise. |
| hideSidebarLinks | 0/1 | Don't show the list of other blog posts with links to them in the sidebar on the present page. |
| hidePostTags | 0/1 | Don't show whatever tags the present blog post has. |
| hideSidebarTagCloud | 0/1 | Don't show the list of all tags with links to the appropriate tag pages. |

All 0/1 settings default to `0`.

Website settings
----------------

The following settings are specified in the file `website.conf` in `inputDir` and affect all pages. The format of `website.conf` is as follows:

    settingNameOne short_value
    settingNameTwo {A value with spaces.}

Values can be quoted with braces (`{value}`) or double quotes (`"value"`).

| Setting name | Example value(s) | Description |
|---------------|------------------|-------------|
| websiteTitle | `{My Awesome Website}` | The text that is displayed in the navbar at the top of every page (Bootstrap's `navbar-brand`) as well as appended to the `<title>` tag of every page's HTML output. For this example value the `<title>` tag of a page will say "Hello! &#124; My Awesome Website" if its `title` is `{Hello!}` .  |
| url | `{http://example.com/}` | The base URL of your static website. It is used for sitemap generation and absolute links such as those in the RSS feed or canonical URLs. The trailing slash is mandatory. |
| outputDir | `../output`, `/var/www/` | The destination directory under which HTML output is produced if no `outputDir` is given in the command line arguments. Relative paths are interpreted as relative to `inputDir`, so, for example, if `outputDir` is set to `../output` and you run Tclssg with the command line arguments `build myproject/input` the effective output directory will be `myproject/output`. |
| generateSitemap | 0/1 | Generate a [sitemap](https://en.wikipedia.org/wiki/Site_map) for the static website. This will create the file `sitemap.xml` in `outputDir` listing all the pages of the static website except those that are explicitly hidden from collections (see the page setting `hideFromCollections`). |
| generateRssFeed | 0/1 | Generate a [RSS feed](https://en.wikipedia.org/wiki/RSS) for the static website. This will create the file `rss.xml` (of `rssFeedFilename`) in `outputDir` with the posts as the first HTML file of the index page. |
| rssFeedFilename | `rss.xml` | |
| rssFeedDescription | `{This is my blog's RSS feed. New posts every week.}` | The `<description>` tag content in the RSS feed. |
| articleTemplateFilename | `article.thtml` | Sets the file name of the desired article template file, which determines what goes between the `<article>...</article>` tags for each page. If no value for this setting is specified then the value `article.thtml` is used. Tclssg looks for the article template file in `inputDir/templates` first then in the `templates` subdirectory of the project skeleton.  |
| documentTemplateFilename | `article.thtml` | Sets the file name of the desired document template file, which determines the HTML document structure of the output (expect for what goes between the `<article>...</article>` tags). If no value for this setting is specified then the value `bootstrap.thtml` is used. Tclssg looks for the page template file in `inputDir/templates` first then in the `templates` subdirectory of the project skeleton. |
| rssArticleTemplateFilename | `rss-article.txml` | |
| rssDocumentTemplateFilename | `rss-feed.txml` | |
| deployCopy | `{ path /var/www/ }` | `path` sets the location to copy the output to when the command `deploy-copy` is run. |
| deployCustom | | See [the corresponding section](#using-deploycustom) below. |
| deployFtp | `{ server {ftp.hosting.example.net} port 21 user deployment password {long password} path htdocs }` | FTP deployment settings: the hostname and port of the server to upload the static website to, the FTP user name and password and the destination path on the server. The port is optional and defaults to 21 but all the other settings are mandatory. The password is not shown in Tclssg's logs. |
| expandMacrosInPages | 0/1 | Whether template macros are allowed in pages. If set to `0` macro code in a page will be treated as Markdown text just like the rest of the page. |
| charset | `utf-8` | The pages' character set. |
| indexPage | `{index.md}` | The index page. |
| blogIndexPage | `{blog/index.md}` | The page that will contain your blog posts in a chronological order. If your blog index is `blog/index.md` the processed content of `blog/index.md` is prepended to each HTML page of the output and its settings will be used for the page settings. |
| tagPage | `{blog/tag.md}` | The page to use as a basis when creating tag pages. If your `tagPage` is set to `blog/tag.md` the processed content of `blog/tag.md` is prepended to each HTML page of every tag page created and its settings will be used for the page settings. |
| blogPostsPerFile | 10 | The maximum number of the blog posts that can be placed on one collection page (i.e., in one HTML file of the blog index page or a tag page). |
| sortTagsBy | `frequency`, `name` | Determines the order in which tags get displayed in the tag cloud. Currently there are two possible settings: `frequency` (most often used tags first) and `name` (default; sort tags alphabetically by the name of the tag itself). |
| maxTagCloudTags | `10`, `-1`, `inf` | How many tags to list in the sidebar. This is intended to be used with `sortTagsBy` set to `frequency` to only display the most common tags when you have a lot of them. Negative numbers or a non-number indicate no limit. |
| maxSidebarLinks | `10`, `-1`, `inf` | How many of the most recent posts to link to in the sidebar. Negative numbers or a non-number indicate no limit. |
| pageVariables | `{ title {Untitled page} }` | The default values for page settings. If a page (either a regular page or a blog post) does npt set a page settings Tclssg will look for that setting's value in `pageVariables` before falling back on a built-in default. If it does set some settings then its value overrides the one in `pageVariables`. |
| blogPostVariables | `{ hideSidebarNote 1 title {Untitled post} }` | The default values for page settings on blog posts. On blog posts the default values set here override those in `pageVariables`. |
| copyright | `{Copyright © $year You. See out <a href="$rootDirPath/privacy.html">privacy policy</a>.}` | A copyright line to display in the footer. HTML is allowed on the copyright notice and the following settings are recognized and substituted: `$rootDirPath` for the relative path to the website root and `$year` for the current year. |
| comments | `{ engine none disqusShortname {} }` | Selects what comment engine (external software or service for blog comments) to use on your websites pages ( expect those that have `hideUserComments` set to `1`). `engine` can be either `none` or `disqus`. For Disqus the value of `disqusShortname` specifies your [shortname](https://help.disqus.com/customer/portal/articles/466208-what-s-a-shortname-), which identifies you to the service. |
| timezone | `:UTC`, `{}` | The time zone that applies to the dates on blog pages. Leave empty to use your computer's the local time zone. |

Like page settings all 0/1 website settings default to `0`.

### Using `deployCustom`

The setting `deployCustom` allows you to define complex deployment scenarios using shell commands (on *nix) or `cmd.exe` commands (on Windows). The value of `deployCustom` consists of three keys, `start`, `file` and `end`, followed by their respective values. The command under the key `file` is run for every file in `outputDir` while `start` and `end` are run once at the beginning and the end of the deployment operation respectively. Here's an example of a `website.conf` that does SCP deployment on `./ssg.tcl deploy-custom`:

    [...]
    deployCustom {
        start {scp -rp "$outputDir" host.example.net:/var/www/}
        file {}
        end {}
    }
    [...]

In the above example `$outputDir` is replaced with the actual output directory path when the command is run. In the commands for `start`, `file` and `end` the following variables are recognized and substituted: `$outputDir` (the output directory), `$file` (file path), `$fileRel` (file path relative to `outputDir`). This means that if you put `file {echo "$fileRel"}` in `deployCustom` and run Tclssg with the command `./ssg.tcl deploy-custom ./website/input ./website/output` it will print the relative paths of all files in `./website/output`.

FAQ
---

Answers to frequently asked questions about Tclssg can be found on the [FAQ wiki page](https://github.com/dbohdan/tclssg/wiki/FAQ).

Sample use session
------------------

    $ ./ssg.tcl build
    Loaded config file:
        websiteTitle {SSG Test}
        url http://example.com/
        generateSitemap 0
        indexPage index.md
        blogIndexPage blog/index.md
        tagPage blog/tag.md
        outputDir ../output
        blogPostsPerFile 10
        pageVariables {
            locale en_US
            hideUserComments 1
            navbarItems {
                Home $indexLink
                Blog $blogIndexLink
                Contact $rootDirPath/contact.html
            }
        }
        blogPostVariables {
            hideUserComments 0
            moreText {(<a href="%s">read more</a>)}
            sidebarNote {
                <h3>About</h3> This is the blog of the sample Tclssg project.
            }
        }
        deployCustom {
            start {
                scp -rp $outputDir localhost:/tmp/deployment-test/
            }
            file {}
            end {}
        }
        expandMacrosInPages 0
        comments {
            engine none
            disqusShortname {}
        }
    adding article collection website/input/pages/blog/index.md with posts {website/input/pages/blog/test-3.md website/input/pages/blog/test-2.md website/input/pages/blog/test.md}
    adding article collection website/input/pages/blog/tag-a-long-tag-with-spaces.md with posts website/input/pages/blog/test.md
    adding article collection website/input/pages/blog/tag-another-thing.md with posts website/input/pages/blog/test-3.md
    adding article collection website/input/pages/blog/tag-something.md with posts website/input/pages/blog/test-2.md
    adding article collection website/input/pages/blog/tag-test.md with posts {website/input/pages/blog/test-3.md website/input/pages/blog/test-2.md website/input/pages/blog/test.md}
    processing page file website/input/pages/blog/test-3.md into website/output/blog/test-3.html
    processing page file website/input/pages/blog/test-2.md into website/output/blog/test-2.html
    processing page file website/input/pages/blog/test.md into website/output/blog/test.html
    processing page file website/input/pages/contact.md into website/output/contact.html
    processing page file website/input/pages/index.md into website/output/index.html
    processing page file website/input/pages/blog/index.md into website/output/blog/index.html
    processing page file website/input/pages/blog/tag.md into website/output/blog/tag.html
    processing page file website/input/pages/blog/index.md into website/output/blog/index.html
    processing page file website/input/pages/blog/tag-a-long-tag-with-spaces.md into website/output/blog/tag-a-long-tag-with-spaces.html
    processing page file website/input/pages/blog/tag-another-thing.md into website/output/blog/tag-another-thing.html
    processing page file website/input/pages/blog/tag-something.md into website/output/blog/tag-something.html
    processing page file website/input/pages/blog/tag-test.md into website/output/blog/tag-test.html
    overwriting website/output/tclssg.css with website/input/static/tclssg.css
    [...]
    overwriting website/output/external/bootstrap-3.2.0-dist/js/bootstrap.min.js with website/input/static/external/bootstrap-3.2.0-dist/js/bootstrap.min.js
    $ ./ssg.tcl deploy-custom
    Loaded config file:
        websiteTitle {SSG Test}
        url http://example.com/
        generateSitemap 0
        indexPage index.md
        blogIndexPage blog/index.md
        tagPage blog/tag.md
        outputDir ../output
        blogPostsPerFile 10
        pageVariables {
            locale en_US
            hideUserComments 1
            navbarItems {
                Home $indexLink
                Blog $blogIndexLink
                Contact $rootDirPath/contact.html
            }
        }
        blogPostVariables {
            hideUserComments 0
            moreText {(<a href="%s">read more</a>)}
            sidebarNote {
                <h3>About</h3> This is the blog of the sample Tclssg project.
            }
        }
        deployCustom {
            start {
                scp -rp $outputDir localhost:/tmp/deployment-test/
            }
            file {}
            end {}
        }
        expandMacrosInPages 0
        comments {
            engine none
            disqusShortname {}
        }
    deploying...
    done.

(If you specify an FTP password in the config the password is automatically replaced with "***" in Tclssg's log output.)

License
-------

MIT. See the file `LICENSE` for details.

The Tclssg logo images are copyright (c) 2014 Danyil Bohdan and are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

The [Caius](https://github.com/tobijk/caius) Markdown package 1.0 is copyright (c) 2014 Caius Project and is distributed under the MIT license. See `external/markdown/markdown.tcl`.

Bootstrap 3.3.1 is copyright (c) 2011-2014 Twitter, Inc and is distributed under the MIT license. See `skeleton/static/external/bootstrap-3.3.1-dist/LICENSE`.
