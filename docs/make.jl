using Documenter
using VAIML

makedocs(
    modules = [VAIML],
    sitename = "VAIML.jl",
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(repo = "github.com/laschuet/VAIML.jl.git")
