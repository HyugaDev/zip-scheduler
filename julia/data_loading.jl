"""
    _split_strip(line, delimiter=',')

Split a line string from a CSV file by a delimiter and strip leading and trailing
whitespace of each substring
"""
_split_strip(line, delimiter=',') = split(line, delimiter; keepempty=false) .|> strip

# Define how to parse different types from strings
function Base.parse(::Type{Priority}, str::AbstractString)
    clean_str = str |> titlecase
    if clean_str == "Emergency"
        return EMERGENCY
    elseif clean_str == "Resupply"
        return RESUPPLY
    else
        error("Invalid priority \"$str\". Valid options are \"Emergency\" or \"Resupply\"")
    end
end
function Base.parse(::Type{Hospital}, line::AbstractString)
    name, north_m, east_m = _split_strip(line)
    return Hospital(
        name = name,
        north_m = parse(Int, north_m),
        east_m = parse(Int, east_m),
    )
end
function Base.parse(::Type{Order}, line::AbstractString, hospital_directory)
    time, hospital_name, priority = _split_strip(line)
    return Order(
        time = parse(Int, time),
        hospital = hospital_directory[hospital_name],
        priority = parse(Priority, priority)
    )
end

"""
    load_from_csv(T::Type, file_name, args...)
    load_from_csv(T::Type{Hospital}, file_name)
    load_from_csv(T::Type{Order}, file_name, hospital_directory)

Load data from a CSV file by parsing each line as the specified type `T`
"""
function load_from_csv(T::Type, file_name, args...)
    return [parse(T, line, args...) for line in readlines(file_name)]
end
