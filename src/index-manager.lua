local IndexManager = {}

function IndexManager.append_node(index_text, node_skeleton_text, post_title, post_date, post_description, post_link)
    local _, node_begin = index_text:find("<.-%sid=\"wv%-post%-nodes\">")
    local node_generated = node_skeleton_text:gsub("{TITLE}", post_title):gsub("{DATE}", post_date):gsub("{DESCRIPTION}", post_description):gsub("{LINK}", post_link)
    local generated = index_text:sub(1, node_begin + 1) .. node_generated .. index_text:sub(node_begin + 1)
    return generated
end

return IndexManager
