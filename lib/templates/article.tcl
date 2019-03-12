# Tclssg, a static website generator.
# Copyright (c) 2013, 2014, 2015, 2016, 2017, 2018
# dbohdan and contributors listed in AUTHORS. This code is released under
# the terms of the MIT license. See the file LICENSE for details.

namespace eval ::article {}
proc ::article::render args {
    named-args {
        -articleInput   articleInput
        -abbreviate     {abbreviate 1}
        -collection     collection
        -collectionTop  collectionTop
        -content        content
        -root           root
    }
    set title [title $collection $collectionTop]
    set headerBlock [author][date]

    set output {}
    if {($content ne "") || ($title ne "") || ($headerBlock ne "")} {
        if {$collection && !$collectionTop} {
            append output <article>
        }
        append output [article-setting {article top} {}]
        append output <header>$title
        if {$headerBlock ne ""} {
            append output "<div class=\"page-info\">$headerBlock</div>"
        }
        append output </header>
        append output [abbreviate-article $content $abbreviate ]
        append output [tag-list]
        append output [article-setting {article bottom} {}]
        if {$collection && !$collectionTop} {
            append output </article>
        }
    }
    return $output
}

namespace eval ::article {    
    proc author {} {
        upvar 1 articleInput articleInput

        set author [article-setting author]
        if {($author eq {%NULL%}) || ![article-setting showAuthor 1]} {
            return {}
        } else {
            return [format {<address class="author">%s</address>} $author]
        }
    }

    proc title {collection collectionTop} {
        upvar 1 articleInput articleInput \
                root root

        set title [article-setting title {}]

        if {$title eq {} ||
            ![article-setting showTitle 1] ||
            ![article-setting showArticleTitle 1]} {
            return {}
        }

        set result {<h1 class="page-title">}

        if {[article-setting blogPost 0] &&
            $collection &&
            !$collectionTop} {
            append result [rel-link [article-output] $title]
        } else {
            append result [entities $title]
        }

        append result {</h1>}

        return $result
    }

    proc article-output {} {
        upvar 1 articleInput articleInput

        set output [input-to-output-path $articleInput \
                                         -includeIndexHtml 0]
        return $output
    }

    proc format-date {htmlClass dateKey timestampKey} {
        upvar 1 articleInput articleInput

        set date [article-setting $dateKey]
        set timestamp [article-setting $timestampKey]

        if {$date eq {%NULL%}} {
            return {}
        } else {
            set dt [clock format [lindex $timestamp 0] \
                                 -format [lindex $timestamp 1]]
            return "<time datetime=\"$dt\" class=\"$htmlClass\">$date</time>"
        }
    }

    # Article creation and modification date.
    proc date {} {
        upvar 1 articleInput articleInput

        set resultList {}
        if {[article-setting showDate 1]} {
            set dateF [format-date date date timestamp]
            if {$dateF ne ""} {
                lappend resultList $dateF
            }
            if {[article-setting showModifiedDate 1]} {
                set modDateF [format-date modified modified modifiedTimestamp]
                if {$modDateF ne ""} {
                    lappend resultList $modDateF
                }
            }
        }
        switch -exact -- [llength $resultList] {
            0 {
                return ""
            }
            1 {
                return [format [mc {Published %1$s}] $dateF]
            }
            default {
                return [format [mc {Published %1$s, updated %2$s}] $dateF $modDateF]
            }
        }
    }

    proc abbreviate-article {content abbreviate {absoluteLink 0}} {
        upvar 1 articleInput articleInput \
                root root

        if {$abbreviate} {
            set link [link-path [article-output] $absoluteLink]
            set moreText [article-setting moreText \
                                          {(<a href="$link">read more</a>)}]
            if {[regexp {(.*?)<!-- *more *-->} $content _ content]} {
                append content \
                       [string map [list \$link [entities $link]] $moreText]
            }
        }
        return $content
    }

    proc tag-list {} {
        upvar 1 articleInput articleInput \
                root root

        set tags [db tags get $articleInput ]
        if {$tags eq {}} {
            return {}
        } else {
            set links {}
            foreach tag $tags {
                lappend links "<li class=\"tag\">[tag-page-link $tag]</li>"
            }

            return "<nav class=\"container-fluid tags\">[format \
                    [mc {Tagged: <ul>%1$s</ul>}] [join \
                    $links]]</nav><!-- tags -->"
        }
    }
}
