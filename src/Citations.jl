"""
Provides functionality to resolve citations. A citation is indicated using `@citation`
for the `url` in a markdown link.
"""
module Citations

import Documenter:
    Documenter,
    Documents,
    Utilities,
    Builder,
    Expanders,
    Writers,
    Anchors

import .Utilities: Selectors
import .Utilities.DOM: @tags
import .Writers.HTMLWriter: domify
import Markdown

using PyCall
const btp = PyNULL()
function __init__()
    copy!(btp, pyimport_conda("bibtexparser", "bibtexparser"))
end

include("walk_and_replace.jl")

# Nodes for citations and bibliographies
include("nodes.jl")

include("CitationStyle.jl")

struct CitationPlugin <: Documenter.Plugin
    bibnodes::Vector{BibliographyNode}
    style::Symbol

    function CitationPlugin(style::Symbol=:default)
        new(Vector{BibliographyNode}(), style)
    end

end

# Extra build steps to register and resolve citations
include("RegisterCitations.jl")
include("GenerateBibliography.jl")
include("ResolveCitations.jl")

# Extend Documenter's Expander step to support bibliographies
include("BibliographyBlocks.jl")

# Extentions to the builtin HTMLWriter
# include("HTMLWriter.jl")

# Parse .bib files and format citations
include("citations.jl")


end # module