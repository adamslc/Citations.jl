abstract type BibliographyBlocks <: Expanders.ExpanderPipeline end
Selectors.order(::Type{BibliographyBlocks}) = 6.0
Selectors.matcher(::Type{BibliographyBlocks}, node, page, doc) = Expanders.iscode(node, "@bibliography")
function Selectors.runner(::Type{BibliographyBlocks}, x, page, doc)
    node = Documents.buildnode(BibliographyNode, x, doc, page)
    if !haskey(doc.internal.extras, :bibnodes)
    	doc.internal.extras[:bibnodes] = Vector{BibliographyNode}()
    end
    push!(doc.internal.extras[:bibnodes], node)
    page.mapping[x] = node
end

struct BibliographyNode
	pages    :: Vector{String}
	bibfile  :: String
    build    :: String
    source   :: String
    elements :: Vector

    function BibliographyNode(;
    		Pages = [],
    		BibFile = "src/assets/bibliography.bib",
            build,
            source,
            others...
        )
        new(Pages, BibFile, build, source, [])
    end
end