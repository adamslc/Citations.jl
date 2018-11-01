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