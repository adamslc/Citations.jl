"""
Register citations with correct bibliography
"""
abstract type RegisterCitations <: Builder.DocumentPipeline end
Selectors.order(::Type{RegisterCitations}) = 4.0
Selectors.matcher(::Type{RegisterCitations}) = true
Selectors.strict(::Type{RegisterCitations}) = false
function Selectors.runner(::Type{RegisterCitations}, doc::Documents.Document)
    Utilities.log(doc, "registering citations.")
    register_citations(doc)
end

function register_citations(doc::Documents.Document)
    for (src, page) in doc.internal.pages
        empty!(page.globals.meta)
        for element in page.elements
            register_citations(page.mapping[element], page, doc)
        end
    end
end

function register_citations(element, page, doc)
    walk_and_replace(page.globals.meta, element) do link
        register_citation(link, page.globals.meta, page, doc)
    end
end

register_citation(other, meta, page, doc) = nothing

function register_citation(link::Markdown.Link, meta, page, doc)
    if occursin(r"^@citation", link.url)
        if link.url == "@citation" && length(link.text) == 1
            citationkey = link.text[1]
            alttext = nothing
        elseif occursin(r"^@citation .+", link.url)
            citationkey = split(link.url)[2]
            alttext = link.text[1]
        else
            Utilities.warn("could not find citation key. Giving up.")
            return false
        end

        # Find the correct bibnode if one exists
        settings = Documents.getplugin(doc, CitationPlugin)
        for bibnode in settings.bibnodes
            if length(bibnode.pages) == 0 || page.source in bibnode.pages
                push!(bibnode.keys, citationkey)
                return CitationNode(citationkey, alttext, bibnode)
            end
        end

        Utilities.warn("citation $citationkey has no bibliography.")
    end

    return nothing
end
