module Citations

using Documenter, Markdown

import Documenter: Expanders, Builder, Documents, Anchors
import Documenter.Utilities: Selectors
import Documenter.Utilities.DOM: @tags

function read_bib_file(filename)
    entries = open(filename) do io
        contents = read(filename, String)

        parser = btp[:bparser][:BibTexParser](common_strings = true)
        parser[:ignore_nonstandard_types] = true
        parser[:interpolate_strings] = true

        parsed = btp[:loads](contents)
        parsed[:entries]
    end

    citations = Dict{String, Any}()
    for entry in entries
        citations[entry["ID"]] = entry
    end

    return(citations)
end

include("BibliographyBlocks.jl")
include("nodes.jl")
include("GenerateBibliography.jl")
include("HTMLWriter.jl")
include("RegisterCitations.jl")
include("walk_and_replace.jl")

end
