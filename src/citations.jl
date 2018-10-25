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

function format_bib_entry(entry)
    authors = strip.(split(entry["author"], "and"))
    authorstr = ""
    for author in authors
        if authorstr != ""
            authorstr *= ", "
        end
        
        name = split(author)
        for piece in name[1:end-1]
            authorstr *= string(uppercase(piece[1]), ". ")
        end
        authorstr *= name[end]
    end

    citation = string(authorstr, ", \"", entry["title"], "\", ",
        entry["journal"], " (", entry["year"], ").")

    return citation
end