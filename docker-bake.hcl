variable "GOMPLATE_VERSION" { default = "alpine" }

target "docker-metadata-action" {}
target "github-metadata-action" {}

target "default" {
    inherits = [ "genconfig" ]
    platforms = [
        "linux/amd64",
        "linux/arm64"
    ]
}

target "local" {
    inherits = [ "genconfig" ]
    tags = [ "swarmlibs/genconfig:local" ]
}

target "genconfig" {
    context = "."
    dockerfile = "Dockerfile"
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    args = {
        GOMPLATE_VERSION = "${GOMPLATE_VERSION}"
    }
}
