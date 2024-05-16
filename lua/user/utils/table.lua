local function find(t, search)
   for k, v in pairs(t) do
      if v == search then
         return k
      end
   end
end

return {
    find = find
}
