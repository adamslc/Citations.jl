abstract type GenerateBibliography <: Builder.DocumentPipeline end
Selectors.order(::Type{GenerateBibliography}) = 5.0
Selectors.matcher(::Type{GenerateBibliography}) = true
Selectors.strict(::Type{GenerateBibliography}) = false
function Selectors.runner(::Type{GenerateBibliography}, doc::Documents.Document)
    Utilities.log(doc, "generating bibliograpies.")
    generate_bibliographies(doc)
end

function generate_bibliographies(doc::Documents.Document)
    for (src, page) in doc.internal.pages
        empty!(page.globals.meta)
        for element in page.elements
            generate_bibliography(element, page.mapping[element], page, doc)
        end
    end
end

generate_bibliography(element, node, page, doc) = nothing
function generate_bibliography(element, bib::BibliographyNode, page, doc)
    Selectors.dispatch(CitationStyle, bib.style, doc, bib)

    list = Markdown.List(1)
    for key in bib.keys
        push!(list.items, bib.database[key][1])
    end

    page.mapping[element] = list
    return nothing
end
