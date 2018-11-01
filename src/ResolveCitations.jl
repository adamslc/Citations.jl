"""
Resolve citations in bibliography, and format bibnodes and citations.
"""
abstract type ResolveCitations <: Builder.DocumentPipeline end
Selectors.order(::Type{ResolveCitations}) = 5.5
Selectors.matcher(::Type{ResolveCitations}) = true
Selectors.strict(::Type{ResolveCitations}) = false
function Selectors.runner(::Type{ResolveCitations}, doc::Documents.Document)
    Utilities.log(doc, "resolving citations.")
    resolve_citations(doc)
end

function resolve_citations(doc::Documents.Document)
	for (src, page) in doc.internal.pages
		empty!(page.globals.meta)
		for element in page.elements
			resolve_citations(page.mapping[element], page, doc)
		end
	end
end

function resolve_citations(element, page, doc)
	walk_and_replace(page.globals.meta, element) do el
		resolve_citation(el, page.globals.meta, page, doc)
	end
end

resolve_citation(other, meta, page, doc) = nothing
function resolve_citation(cite::CitationNode, meta, page, doc)
	return cite.bibnode.database[cite.key][2]
end