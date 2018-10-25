"""
Register citations with correct bibliography
"""
abstract type ResolveCitations <: Builder.DocumentPipeline end
Selectors.order(::Type{ResolveCitations}) = 4.0
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
	Documents.walk(page.globals.meta, element) do link
		resolve_citation(link, page.globals.meta, page, doc)
	end
end

resolve_citation(other, meta, page, doc) = true
function resolve_citation(link::Markdown.Link, meta, page, doc)
	if occursin(r"^@citation", link.url)
		if link.url == "@citation" && length(link.text) == 1
			citationkey = link.text[1]
		elseif occursin(r"^@citation .+", link.url)
			citationkey = split(link.url)[2]
		else
			Utilities.warn("could not find citation key. Giving up.")
			return false
		end

		# Find the correct bibnode if one exists
		for bibnode in doc.internal.extras[:bibnodes]
			if length(bibnode.pages) == 0 || page.source in bibnode.pages
				push!(bibnode.elements, citationkey)
				path = relpath(bibnode.build, dirname(page.build))
				link.url = string(path, '#', citationkey)
				return false
			end
		end

		Utilities.warn("citation $citationkey has no bibliography.")
	end

	return false
end