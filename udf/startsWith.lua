local function starts_with(map,rec)
  if rec.username:find('^' .. map['chars']) ~= nil then
    local user_info = rec.username .. ':' .. rec.tweetCount -- add colon as a delimiter like so xxxxx:##

    map['users'] = map['users'] .. ',' .. user_info -- add comma as a demiliter like so xxxxxx:##,xx:#
  end

  return map
end

local function reduce_stats(a,b)
  -- Merge values from map b into a
  a.users = a.users .. b.users
  -- Return updated map a
  return a
end

function find(stream,chars)
  -- Process incoming record stream and pass it to aggregate function, then to reduce function
  --   NOTE: aggregate function starts_with accepts two parameters: 
  --    1) A map that contains usernames and initial chars to match username  
  --    2) function name starts_with -- which will be called for each record as it flows in
  -- Return reduced value of the map generated by reduce function reduce_stats
  return stream : aggregate(map{users='',chars=chars},starts_with) : reduce(reduce_stats)
end
