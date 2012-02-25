util = require 'util'

trim = (string) ->
    string.replace /^\s*|\s*$/, ""
        
    
explode = (string, delim, limit) ->
    return string.split(delim) unless limit
    parts = string.split(delim)
    result = parts.slice(0, limit - 1)
    result.push parts.slice(limit - 1).join(delim)
    result


parse_header: (header) ->
    result = {}
    header = header.split(";")
    result.value = trim(header[0])
        
    for i in [1..header.length]
        continue if header[i] is ""
        tupple = explode(header[i], "=", 2)      
        if tupple.length is 2
            result[trim(tupple[0])] = trim(tupple[1]).replace(/^"/, "").replace(/"$/, "")
        else
            result[trim(tupple[0])] = ""
        
    result
    
    
parse_header_block = (content) ->
    result = {}
    return result if content is ""
    header = content.split("\r\n")
        
    for i in [0..header.length]
        tupple = explode(header[i], ":", 2)
        if header[i].match(/^\s+/) or tupple.length < 2
            if key? and header[i].match(/^\s+/)
                result[key] += " " + trim(arr[i])
            continue
        key = tupple[0].toLowerCase()
        result[key] = tupple[1]
    
    for key of result
        result[key] = parse_header(result[key])
        
    result
        
    
parse_body_block = (content, headers) ->
    headers["content-type"] = value: "text/plain" unless headers["content-type"]
    switch headers["content-type"].value
        when "text/plain", "text/html"
            return [
                "content-type": "text/plain"
                content: content
            ]
        when "multipart/mixed"
            content = parse_multitype(content, headers["content-type"].boundary)
        when "multipart/alternative"
            content = parse_multitype(content, headers["content-type"].boundary)
        when "image/png", "image/jpeg"
            content = content.replace(/\r\n/g, "")
        else
        
    content
        
        
parse_multitype = (content, boundary) ->
    return false if not content or not boundary
    content = content.split("--" + boundary + "\r\n")
        
    for i in [0..content.length]
        content[i] = parse_part(content[i])
        
    content
        
        
parse = (content) ->
    content = explode(content, "\r\n\r\n", 2)
    header = parse_header_block(content[0])
        
    if content.length is 2
        body = parse_body_block(content[1], header)
    else
        body = ""
            
    header: header
    body: body
        
    
exports.parseMail = parse