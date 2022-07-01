variable "TAG" {
    default = "latest"
}

group "default" {
    targets = ["app"]
}

target "app" {
    cache-from = [
        "ghcr.io/oanqa/k8s-controller-sidecars"
    ]

    tags = [
        "ghcr.io/oanqa/k8s-controller-sidecars:${TAG}"
    ]
}