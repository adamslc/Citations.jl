function helper(f, meta, block, childsym)
    result = f(block)
    if result !== nothing
        return result
    end

    result = walk_and_replace(f, meta, getfield(block, childsym))
    if result !== nothing
        setfield!(block, childsym, result)
    end

    return nothing
end

walk_and_replace(f, meta, element) = f(element)

function walk_and_replace(f, meta, block::Vector)
    for (i, each) in enumerate(block)
        result = walk_and_replace(f, meta, each)
        if result !== nothing
            block[i] = result
        end
    end
end

const MDContentElements = Union{
    Markdown.BlockQuote,
    Markdown.Paragraph,
    Markdown.MD,
}
walk_and_replace(f, meta, block::MDContentElements) = helper(f, meta, block, :content)

const MDTextElements = Union{
    Markdown.Bold,
    Markdown.Header,
    Markdown.Italic,
}
walk_and_replace(f, meta, block::MDTextElements)      = helper(f, meta, block, :text)
walk_and_replace(f, meta, block::Markdown.Footnote)   = helper(f, meta, block, :text)
walk_and_replace(f, meta, block::Markdown.Admonition) = helper(f, meta, block, :content)
walk_and_replace(f, meta, block::Markdown.Image)      = helper(f, meta, block, :alt)
walk_and_replace(f, meta, block::Markdown.Table)      = helper(f, meta, block, :rows)
walk_and_replace(f, meta, block::Markdown.List)       = helper(f, meta, block, :items)
walk_and_replace(f, meta, block::Markdown.Link)       = helper(f, meta, block, :text)
walk_and_replace(f, meta, block::Documents.RawHTML)   = nothing
walk_and_replace(f, meta, block::Documents.DocsNodes) = helper(f, meta, block, :nodes)
walk_and_replace(f, meta, block::Documents.DocsNode)  = helper(f, meta, block, :docstr)
walk_and_replace(f, meta, block::Documents.EvalNode)  = helper(f, meta, block, :result)
walk_and_replace(f, meta, block::Documents.MetaNode)  = (merge!(meta, block.dict); nothing)
walk_and_replace(f, meta, block::Anchors.Anchor)      = helper(f, meta, block, :object)