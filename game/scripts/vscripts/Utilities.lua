local CUtilities = {
    Pack =  table.pack or function (...) return {...} end;
    Unpack = table.unpack or unpack
}

return CUtilities