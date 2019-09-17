abstract type BibliographyBlocks <: Expanders.ExpanderPipeline end

Selectors.order(::Type{BibliographyBlocks}) = 6.0
Selectors.matcher(::Type{BibliographyBlocks}, node, page, doc) = Expanders.iscode(node, "@bibliography")
function Selectors.runner(::Type{BibliographyBlocks}, x, page, doc)
    node = Documents.buildnode(BibliographyNode, x, doc, page)
    settings = Documents.getplugin(doc, CitationPlugin)
    push!(settings.bibnodes, node)
    node.style === nothing && (node.style = settings.style)
    page.mapping[x] = node
end
