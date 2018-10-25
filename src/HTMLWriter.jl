function domify(ctx, navnode, bib::BibliographyNode)
    @tags p li ul

    entries = read_bib_file(bib.bibfile)

    lis = []
    for el in bib.elements
        if !haskey(entries, el)
        	Utilities.warn("could not find bib entry for $el.")
        	continue
        end

        citation = format_bib_entry(entries[el])
        push!(lis, li(p[:id=>el](citation)))
    end

    ul(lis)
end