# Possible actions:
#   :preprocess
#   :bibentry
#   :textentry
abstract type CitationStyle <: Selectors.AbstractSelector end

abstract type DefaultStyle <: CitationStyle end
Selectors.order(::Type{DefaultStyle}) = 1.0
Selectors.matcher(::Type{DefaultStyle}, fmt, doc, node) = fmt === :default
Selectors.runner(::Type{DefaultStyle}, fmt, doc, node) = format_bibentries(node)

function format_bibentries(node::BibliographyNode)
    unique!(node.keys)

    for key in node.keys
        if !haskey(node.bibdatabase, key)
            @warn "Could not find information for key $key."
            node.database[key] = (key, key)
            continue
        end
        node.database[key] = format_entry(node.bibdatabase[key])
    end
end

format_entry(entry) = (format_bibentry(entry), format_textentry(entry))

function format_bibentry(entry)
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

    journal = get(entry, "journal", "")

    citation = string(authorstr, ", \"", entry["title"], "\", ",
        journal, " (", entry["year"], ").")

    return citation
end

function format_textentry(entry)
    authors = strip.(split(entry["author"], "and"))
    lastname = split(authors[1])[end]
    year = entry["year"]

    return string("[", lastname, year, "]")
end
