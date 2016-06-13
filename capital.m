% capitalizes each word in a string
function res = capital( str )
    res = regexprep(str,'(\<[a-z])','${upper($1)}');
end
