PACKAGES = [
    {
        "name": "argparse@2.0.1",
        "url": "https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz#246f50f3ca78a3240f6c997e8a9bd1eac49e4b38",
        "integrity": "sha512-8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==",
        "deps": [],
    },
    {
        "name": "google-protobuf@3.13.0",
        "url": "https://registry.yarnpkg.com/google-protobuf/-/google-protobuf-3.13.0.tgz#909c5983d75dd6101ed57c79e0528d000cdc3251",
        "integrity": "sha512-ZIf3qfLFayVrPvAjeKKxO5FRF1/NwRxt6Dko+fWEMuHwHbZx8/fcaAao9b0wCM6kr8qeg2te8XTpyuvKuD9aKw==",
        "deps": [],
    },
    {
        "name": "prettier@2.1.2",
        "url": "https://registry.yarnpkg.com/prettier/-/prettier-2.1.2.tgz#3050700dae2e4c8b67c4c3f666cdb8af405e1ce5",
        "integrity": "sha512-16c7K+x4qVlJg9rEbXl7HEGmQyZlG4R9AgP+oHKRMsMsuk8s+ATStlf1NpDqyBI1HpVyfjLOeMhH2LvuNvV5Vg==",
        "deps": [],
    },
]

ROOTS = [
    {
        "name": "argparse",
        "dep": "argparse@2.0.1",
    },
    {
        "name": "prettier",
        "dep": "prettier@2.1.2",
    },
    {
        "name": "google-protobuf",
        "dep": "google-protobuf@3.13.0",
    },
]
