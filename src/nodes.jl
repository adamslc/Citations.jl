mutable struct BibliographyNode
	pages::Vector{String}
	bibfile::String
    bibdatabase::Dict{String, Any}
    database::Dict{String, Tuple{Any, Any}}
    style::Union{Symbol, Nothing}
    build::String
    source::String
    keys::Vector

    function BibliographyNode(;
    		Pages = [],
    		BibFile = "src/assets/bibliography.bib",
            Style = nothing,
            build,
            source,
            others...
        )

        bibdatabase = read_bib_file(BibFile)
        database = Dict{String, Tuple{Any, Any}}()

        new(Pages, BibFile, bibdatabase, database, Style, build, source, [])
    end
end

struct CitationNode
    key::String
    alttext::Union{String, Nothing}
    bibnode::Union{BibliographyNode, Nothing}
end