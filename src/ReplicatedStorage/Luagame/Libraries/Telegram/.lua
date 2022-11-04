local VariableA = true

if true then
    print(VariableA)
    local VariableB = true
    if true then
        print(VariableB)
        print(VariableA)

        local VariableC = true
    end

    print(VariableC) --> Errors
end
print(VariableB) --> Errors