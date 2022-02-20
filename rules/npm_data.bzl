PACKAGES = {
    "@ampproject/remapping@2.1.1": {
        "deps": [
            {
                "id": "@jridgewell/trace-mapping@0.3.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Aolwjd7HSC2PyY0fDj/wA/EimQT4HfEnFYNp5s9CQlrdhyvWTtvZ5YzrUPu6R6/1jKiUlxu8bUhkdSnKHNAHMA==",
        "name": "@ampproject/remapping",
        "url": "https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.1.1.tgz",
    },
    "@babel/code-frame@7.16.7": {
        "deps": [
            {
                "id": "@babel/highlight@7.16.10",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-iAXqUn8IIeBTNd72xsFlgaXHkMBMt6y4HJp1tIaK465CWLT/fG1aqB7ykr95gHHmlBdGbFeWWfyB4NJJ0nmeIg==",
        "name": "@babel/code-frame",
        "url": "https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.16.7.tgz",
    },
    "@babel/compat-data@7.17.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-392byTlpGWXMv4FbyWw3sAZ/FrW/DrwqLGXpy0mbyNe9Taqv1mg9yON5/o0cnr8XYCkFTZbC1eV+c+LAROgrng==",
        "name": "@babel/compat-data",
        "url": "https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.17.0.tgz",
    },
    "@babel/core@7.17.2": {
        "deps": [
            {
                "id": "@ampproject/remapping@2.1.1",
            },
            {
                "id": "@babel/code-frame@7.16.7",
            },
            {
                "id": "@babel/generator@7.17.0",
            },
            {
                "id": "@babel/helper-module-transforms@7.16.7",
            },
            {
                "id": "@babel/helpers@7.17.2",
            },
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@babel/template@7.16.7",
            },
            {
                "id": "@babel/traverse@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "convert-source-map@1.8.0",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "gensync@1.0.0-beta.2",
            },
            {
                "id": "json5@2.2.0",
            },
            {
                "id": "semver@6.3.0",
            },
        ],
        "extra_deps": {
            "@babel/helper-compilation-targets@7.16.7-bc12e43b": [
                {
                    "id": "@babel/core@7.17.2",
                },
            ],
            "@babel/core@7.17.2": [
                {
                    "id": "@babel/helper-compilation-targets@7.16.7-bc12e43b",
                },
            ],
        },
        "integrity": "sha512-R3VH5G42VSDolRHyUO4V2cfag8WHcZyxdq5Z/m8Xyb92lW/Erm/6kM+XtRFGf3Mulre3mveni2NHfEUws8wSvw==",
        "name": "@babel/core",
        "url": "https://registry.npmjs.org/@babel/core/-/core-7.17.2.tgz",
    },
    "@babel/generator@7.17.0": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "jsesc@2.5.2",
            },
            {
                "id": "source-map@0.5.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-I3Omiv6FGOC29dtlZhkfXO6pgkmukJSlT26QjVvS1DGZe/NzSVCPG41X0tS21oZkJYlovfj9qDWgKP+Cn4bXxw==",
        "name": "@babel/generator",
        "url": "https://registry.npmjs.org/@babel/generator/-/generator-7.17.0.tgz",
    },
    "@babel/helper-compilation-targets@7.16.7": {
        "deps": [
            {
                "id": "@babel/compat-data@7.17.0",
            },
            {
                "id": "@babel/helper-validator-option@7.16.7",
            },
            {
                "id": "browserslist@4.19.1",
            },
            {
                "id": "semver@6.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mGojBwIWcwGD6rfqgRXVlVYmPAv7eOpIemUG3dGnDdCY4Pae70ROij3XmfrH6Fa1h1aiDylpglbZyktfzyo/hA==",
        "name": "@babel/helper-compilation-targets",
        "url": "https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.16.7.tgz",
    },
    "@babel/helper-compilation-targets@7.16.7-bc12e43b": {
        "deps": [
            {
                "id": "@babel/compat-data@7.17.0",
            },
            {
                "id": "@babel/helper-validator-option@7.16.7",
            },
            {
                "id": "browserslist@4.19.1",
            },
            {
                "id": "semver@6.3.0",
            },
        ],
        "extra_deps": {
            "@babel/helper-compilation-targets@7.16.7-bc12e43b": [
                {
                    "id": "@babel/core@7.17.2",
                },
            ],
            "@babel/core@7.17.2": [
                {
                    "id": "@babel/helper-compilation-targets@7.16.7-bc12e43b",
                },
            ],
        },
        "integrity": "sha512-mGojBwIWcwGD6rfqgRXVlVYmPAv7eOpIemUG3dGnDdCY4Pae70ROij3XmfrH6Fa1h1aiDylpglbZyktfzyo/hA==",
        "name": "@babel/helper-compilation-targets",
        "url": "https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.16.7.tgz",
    },
    "@babel/helper-environment-visitor@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-SLLb0AAn6PkUeAfKJCCOl9e1R53pQlGAfc4y4XuMRZfqeMYLE0dM1LMhqbGAlGQY0lfw5/ohoYWAe9V1yibRag==",
        "name": "@babel/helper-environment-visitor",
        "url": "https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.16.7.tgz",
    },
    "@babel/helper-function-name@7.16.7": {
        "deps": [
            {
                "id": "@babel/helper-get-function-arity@7.16.7",
            },
            {
                "id": "@babel/template@7.16.7",
            },
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-QfDfEnIUyyBSR3HtrtGECuZ6DAyCkYFp7GHl75vFtTnn6pjKeK0T1DB5lLkFvBea8MdaiUABx3osbgLyInoejA==",
        "name": "@babel/helper-function-name",
        "url": "https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.16.7.tgz",
    },
    "@babel/helper-get-function-arity@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-flc+RLSOBXzNzVhcLu6ujeHUrD6tANAOU5ojrRx/as+tbzf8+stUCj7+IfRRoAbEZqj/ahXEMsjhOhgeZsrnTw==",
        "name": "@babel/helper-get-function-arity",
        "url": "https://registry.npmjs.org/@babel/helper-get-function-arity/-/helper-get-function-arity-7.16.7.tgz",
    },
    "@babel/helper-hoist-variables@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-m04d/0Op34H5v7pbZw6pSKP7weA6lsMvfiIAMeIvkY/R4xQtBSMFEigu9QTZ2qB/9l22vsxtM8a+Q8CzD255fg==",
        "name": "@babel/helper-hoist-variables",
        "url": "https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.16.7.tgz",
    },
    "@babel/helper-module-imports@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LVtS6TqjJHFc+nYeITRo6VLXve70xmq7wPhWTqDJusJEgGmkAACWwMiTNrvfoQo6hEhFwAIixNkvB0jPXDL8Wg==",
        "name": "@babel/helper-module-imports",
        "url": "https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.16.7.tgz",
    },
    "@babel/helper-module-transforms@7.16.7": {
        "deps": [
            {
                "id": "@babel/helper-environment-visitor@7.16.7",
            },
            {
                "id": "@babel/helper-module-imports@7.16.7",
            },
            {
                "id": "@babel/helper-simple-access@7.16.7",
            },
            {
                "id": "@babel/helper-split-export-declaration@7.16.7",
            },
            {
                "id": "@babel/helper-validator-identifier@7.16.7",
            },
            {
                "id": "@babel/template@7.16.7",
            },
            {
                "id": "@babel/traverse@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-gaqtLDxJEFCeQbYp9aLAefjhkKdjKcdh6DB7jniIGU3Pz52WAmP268zK0VgPz9hUNkMSYeH976K2/Y6yPadpng==",
        "name": "@babel/helper-module-transforms",
        "url": "https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.16.7.tgz",
    },
    "@babel/helper-plugin-utils@7.16.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Qg3Nk7ZxpgMrsox6HreY1ZNKdBq7K72tDSliA6dCl5f007jR4ne8iD5UzuNnCJH2xBf2BEEVGr+/OL6Gdp7RxA==",
        "name": "@babel/helper-plugin-utils",
        "url": "https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.16.7.tgz",
    },
    "@babel/helper-simple-access@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZIzHVyoeLMvXMN/vok/a4LWRy8G2v205mNP0XOuf9XRLyX5/u9CnVulUtDgUTama3lT+bf/UqucuZjqiGuTS1g==",
        "name": "@babel/helper-simple-access",
        "url": "https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.16.7.tgz",
    },
    "@babel/helper-split-export-declaration@7.16.7": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xbWoy/PFoxSWazIToT9Sif+jJTlrMcndIsaOKvTA6u7QEo7ilkRZpjew18/W3c7nm8fXdUDXh02VXTbZ0pGDNw==",
        "name": "@babel/helper-split-export-declaration",
        "url": "https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.16.7.tgz",
    },
    "@babel/helper-validator-identifier@7.16.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hsEnFemeiW4D08A5gUAZxLBTXpZ39P+a+DGDsHw1yxqyQ/jzFEnxf5uTEGp+3bzAbNOxU1paTgYS4ECU/IgfDw==",
        "name": "@babel/helper-validator-identifier",
        "url": "https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.16.7.tgz",
    },
    "@babel/helper-validator-option@7.16.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TRtenOuRUVo9oIQGPC5G9DgK4743cdxvtOw0weQNpZXaS16SCBi5MNjZF8vba3ETURjZpTbVn7Vvcf2eAwFozQ==",
        "name": "@babel/helper-validator-option",
        "url": "https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.16.7.tgz",
    },
    "@babel/helpers@7.17.2": {
        "deps": [
            {
                "id": "@babel/template@7.16.7",
            },
            {
                "id": "@babel/traverse@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0Qu7RLR1dILozr/6M0xgj+DFPmi6Bnulgm9M8BVa9ZCWxDqlSnqt3cf8IDPB5m45sVXUZ0kuQAgUrdSFFH79fQ==",
        "name": "@babel/helpers",
        "url": "https://registry.npmjs.org/@babel/helpers/-/helpers-7.17.2.tgz",
    },
    "@babel/highlight@7.16.10": {
        "deps": [
            {
                "id": "@babel/helper-validator-identifier@7.16.7",
            },
            {
                "id": "chalk@2.4.2",
            },
            {
                "id": "js-tokens@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5FnTQLSLswEj6IkgVw5KusNUUFY9ZGqe/TRFnP/BKYHYgfh7tc+C7mwiy95/yNP7Dh9x580Vv8r7u7ZfTBFxdw==",
        "name": "@babel/highlight",
        "url": "https://registry.npmjs.org/@babel/highlight/-/highlight-7.16.10.tgz",
    },
    "@babel/parser@7.17.0": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VKXSCQx5D8S04ej+Dqsr1CzYvvWgf20jIw2D+YhQCrIlr2UZGaDds23Y0xg75/skOxpLCRpUZvk/1EAVkGoDOw==",
        "name": "@babel/parser",
        "url": "https://registry.npmjs.org/@babel/parser/-/parser-7.17.0.tgz",
    },
    "@babel/plugin-syntax-async-generators@7.8.4": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tycmZxkGfZaxhMRbXlPXuVFpdWlXpir2W4AMhSJgRKzk/eDlIXOhb2LHWoLpDF7TEHylV5zNhykX6KAgHJmTNw==",
        "name": "@babel/plugin-syntax-async-generators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz",
    },
    "@babel/plugin-syntax-async-generators@7.8.4-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tycmZxkGfZaxhMRbXlPXuVFpdWlXpir2W4AMhSJgRKzk/eDlIXOhb2LHWoLpDF7TEHylV5zNhykX6KAgHJmTNw==",
        "name": "@babel/plugin-syntax-async-generators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz",
    },
    "@babel/plugin-syntax-async-generators@7.8.4-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tycmZxkGfZaxhMRbXlPXuVFpdWlXpir2W4AMhSJgRKzk/eDlIXOhb2LHWoLpDF7TEHylV5zNhykX6KAgHJmTNw==",
        "name": "@babel/plugin-syntax-async-generators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz",
    },
    "@babel/plugin-syntax-bigint@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wnTnFlG+YxQm3vDxpGE57Pj0srRU4sHE/mDkt1qv2YJJSeUAec2ma4WLUnUPeKjyrfntVwe/N6dCXpU+zL3Npg==",
        "name": "@babel/plugin-syntax-bigint",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz",
    },
    "@babel/plugin-syntax-bigint@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wnTnFlG+YxQm3vDxpGE57Pj0srRU4sHE/mDkt1qv2YJJSeUAec2ma4WLUnUPeKjyrfntVwe/N6dCXpU+zL3Npg==",
        "name": "@babel/plugin-syntax-bigint",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz",
    },
    "@babel/plugin-syntax-bigint@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wnTnFlG+YxQm3vDxpGE57Pj0srRU4sHE/mDkt1qv2YJJSeUAec2ma4WLUnUPeKjyrfntVwe/N6dCXpU+zL3Npg==",
        "name": "@babel/plugin-syntax-bigint",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz",
    },
    "@babel/plugin-syntax-class-properties@7.12.13": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-fm4idjKla0YahUNgFNLCB0qySdsoPiZP3iQE3rky0mBUtMZ23yDJ9SJdg6dXTSDnulOVqiF3Hgr9nbXvXTQZYA==",
        "name": "@babel/plugin-syntax-class-properties",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz",
    },
    "@babel/plugin-syntax-class-properties@7.12.13-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-fm4idjKla0YahUNgFNLCB0qySdsoPiZP3iQE3rky0mBUtMZ23yDJ9SJdg6dXTSDnulOVqiF3Hgr9nbXvXTQZYA==",
        "name": "@babel/plugin-syntax-class-properties",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz",
    },
    "@babel/plugin-syntax-class-properties@7.12.13-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-fm4idjKla0YahUNgFNLCB0qySdsoPiZP3iQE3rky0mBUtMZ23yDJ9SJdg6dXTSDnulOVqiF3Hgr9nbXvXTQZYA==",
        "name": "@babel/plugin-syntax-class-properties",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz",
    },
    "@babel/plugin-syntax-import-meta@7.10.4": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Yqfm+XDx0+Prh3VSeEQCPU81yC+JWZ2pDPFSS4ZdpfZhp4MkFMaDC1UqseovEKwSUpnIL7+vK+Clp7bfh0iD7g==",
        "name": "@babel/plugin-syntax-import-meta",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz",
    },
    "@babel/plugin-syntax-import-meta@7.10.4-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Yqfm+XDx0+Prh3VSeEQCPU81yC+JWZ2pDPFSS4ZdpfZhp4MkFMaDC1UqseovEKwSUpnIL7+vK+Clp7bfh0iD7g==",
        "name": "@babel/plugin-syntax-import-meta",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz",
    },
    "@babel/plugin-syntax-import-meta@7.10.4-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Yqfm+XDx0+Prh3VSeEQCPU81yC+JWZ2pDPFSS4ZdpfZhp4MkFMaDC1UqseovEKwSUpnIL7+vK+Clp7bfh0iD7g==",
        "name": "@babel/plugin-syntax-import-meta",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz",
    },
    "@babel/plugin-syntax-json-strings@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lY6kdGpWHvjoe2vk4WrAapEuBR69EMxZl+RoGRhrFGNYVK8mOPAW8VfbT/ZgrFbXlDNiiaxQnAtgVCZ6jv30EA==",
        "name": "@babel/plugin-syntax-json-strings",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz",
    },
    "@babel/plugin-syntax-json-strings@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lY6kdGpWHvjoe2vk4WrAapEuBR69EMxZl+RoGRhrFGNYVK8mOPAW8VfbT/ZgrFbXlDNiiaxQnAtgVCZ6jv30EA==",
        "name": "@babel/plugin-syntax-json-strings",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz",
    },
    "@babel/plugin-syntax-json-strings@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lY6kdGpWHvjoe2vk4WrAapEuBR69EMxZl+RoGRhrFGNYVK8mOPAW8VfbT/ZgrFbXlDNiiaxQnAtgVCZ6jv30EA==",
        "name": "@babel/plugin-syntax-json-strings",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz",
    },
    "@babel/plugin-syntax-logical-assignment-operators@7.10.4": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-d8waShlpFDinQ5MtvGU9xDAOzKH47+FFoney2baFIoMr952hKOLp1HR7VszoZvOsV/4+RRszNY7D17ba0te0ig==",
        "name": "@babel/plugin-syntax-logical-assignment-operators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz",
    },
    "@babel/plugin-syntax-logical-assignment-operators@7.10.4-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-d8waShlpFDinQ5MtvGU9xDAOzKH47+FFoney2baFIoMr952hKOLp1HR7VszoZvOsV/4+RRszNY7D17ba0te0ig==",
        "name": "@babel/plugin-syntax-logical-assignment-operators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz",
    },
    "@babel/plugin-syntax-logical-assignment-operators@7.10.4-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-d8waShlpFDinQ5MtvGU9xDAOzKH47+FFoney2baFIoMr952hKOLp1HR7VszoZvOsV/4+RRszNY7D17ba0te0ig==",
        "name": "@babel/plugin-syntax-logical-assignment-operators",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz",
    },
    "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-aSff4zPII1u2QD7y+F8oDsz19ew4IGEJg9SVW+bqwpwtfFleiQDMdzA/R+UlWDzfnHFCxxleFT0PMIrR36XLNQ==",
        "name": "@babel/plugin-syntax-nullish-coalescing-operator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz",
    },
    "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-aSff4zPII1u2QD7y+F8oDsz19ew4IGEJg9SVW+bqwpwtfFleiQDMdzA/R+UlWDzfnHFCxxleFT0PMIrR36XLNQ==",
        "name": "@babel/plugin-syntax-nullish-coalescing-operator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz",
    },
    "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-aSff4zPII1u2QD7y+F8oDsz19ew4IGEJg9SVW+bqwpwtfFleiQDMdzA/R+UlWDzfnHFCxxleFT0PMIrR36XLNQ==",
        "name": "@babel/plugin-syntax-nullish-coalescing-operator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz",
    },
    "@babel/plugin-syntax-numeric-separator@7.10.4": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9H6YdfkcK/uOnY/K7/aA2xpzaAgkQn37yzWUMRK7OaPOqOpGS1+n0H5hxT9AUw9EsSjPW8SVyMJwYRtWs3X3ug==",
        "name": "@babel/plugin-syntax-numeric-separator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz",
    },
    "@babel/plugin-syntax-numeric-separator@7.10.4-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9H6YdfkcK/uOnY/K7/aA2xpzaAgkQn37yzWUMRK7OaPOqOpGS1+n0H5hxT9AUw9EsSjPW8SVyMJwYRtWs3X3ug==",
        "name": "@babel/plugin-syntax-numeric-separator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz",
    },
    "@babel/plugin-syntax-numeric-separator@7.10.4-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9H6YdfkcK/uOnY/K7/aA2xpzaAgkQn37yzWUMRK7OaPOqOpGS1+n0H5hxT9AUw9EsSjPW8SVyMJwYRtWs3X3ug==",
        "name": "@babel/plugin-syntax-numeric-separator",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz",
    },
    "@babel/plugin-syntax-object-rest-spread@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XoqMijGZb9y3y2XskN+P1wUGiVwWZ5JmoDRwx5+3GmEplNyVM2s2Dg8ILFQm8rWM48orGy5YpI5Bl8U1y7ydlA==",
        "name": "@babel/plugin-syntax-object-rest-spread",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz",
    },
    "@babel/plugin-syntax-object-rest-spread@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XoqMijGZb9y3y2XskN+P1wUGiVwWZ5JmoDRwx5+3GmEplNyVM2s2Dg8ILFQm8rWM48orGy5YpI5Bl8U1y7ydlA==",
        "name": "@babel/plugin-syntax-object-rest-spread",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz",
    },
    "@babel/plugin-syntax-object-rest-spread@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XoqMijGZb9y3y2XskN+P1wUGiVwWZ5JmoDRwx5+3GmEplNyVM2s2Dg8ILFQm8rWM48orGy5YpI5Bl8U1y7ydlA==",
        "name": "@babel/plugin-syntax-object-rest-spread",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-catch-binding@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6VPD0Pc1lpTqw0aKoeRTMiB+kWhAoT24PA+ksWSBrFtl5SIRVpZlwN3NNPQjehA2E/91FV3RjLWoVTglWcSV3Q==",
        "name": "@babel/plugin-syntax-optional-catch-binding",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-catch-binding@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6VPD0Pc1lpTqw0aKoeRTMiB+kWhAoT24PA+ksWSBrFtl5SIRVpZlwN3NNPQjehA2E/91FV3RjLWoVTglWcSV3Q==",
        "name": "@babel/plugin-syntax-optional-catch-binding",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-catch-binding@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6VPD0Pc1lpTqw0aKoeRTMiB+kWhAoT24PA+ksWSBrFtl5SIRVpZlwN3NNPQjehA2E/91FV3RjLWoVTglWcSV3Q==",
        "name": "@babel/plugin-syntax-optional-catch-binding",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-chaining@7.8.3": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KoK9ErH1MBlCPxV0VANkXW2/dw4vlbGDrFgz8bmUsBGYkFRcbRwMh6cIJubdPrkxRwuGdtCk0v/wPTKbQgBjkg==",
        "name": "@babel/plugin-syntax-optional-chaining",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-chaining@7.8.3-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KoK9ErH1MBlCPxV0VANkXW2/dw4vlbGDrFgz8bmUsBGYkFRcbRwMh6cIJubdPrkxRwuGdtCk0v/wPTKbQgBjkg==",
        "name": "@babel/plugin-syntax-optional-chaining",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz",
    },
    "@babel/plugin-syntax-optional-chaining@7.8.3-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KoK9ErH1MBlCPxV0VANkXW2/dw4vlbGDrFgz8bmUsBGYkFRcbRwMh6cIJubdPrkxRwuGdtCk0v/wPTKbQgBjkg==",
        "name": "@babel/plugin-syntax-optional-chaining",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz",
    },
    "@babel/plugin-syntax-top-level-await@7.14.5": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hx++upLv5U1rgYfwe1xBQUhRmU41NEvpUvrp8jkrSCdvGSnM5/qdRMtylJ6PG5OFkBaHkbTAKTnd3/YyESRHFw==",
        "name": "@babel/plugin-syntax-top-level-await",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz",
    },
    "@babel/plugin-syntax-top-level-await@7.14.5-960d8897": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hx++upLv5U1rgYfwe1xBQUhRmU41NEvpUvrp8jkrSCdvGSnM5/qdRMtylJ6PG5OFkBaHkbTAKTnd3/YyESRHFw==",
        "name": "@babel/plugin-syntax-top-level-await",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz",
    },
    "@babel/plugin-syntax-top-level-await@7.14.5-f9e5bbd4": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hx++upLv5U1rgYfwe1xBQUhRmU41NEvpUvrp8jkrSCdvGSnM5/qdRMtylJ6PG5OFkBaHkbTAKTnd3/YyESRHFw==",
        "name": "@babel/plugin-syntax-top-level-await",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz",
    },
    "@babel/plugin-syntax-typescript@7.16.7": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-YhUIJHHGkqPgEcMYkPCKTyGUdoGKWtopIycQyjJH8OjvRgOYsXsaKehLVPScKJWAULPxMa4N1vCe6szREFlZ7A==",
        "name": "@babel/plugin-syntax-typescript",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.16.7.tgz",
    },
    "@babel/plugin-syntax-typescript@7.16.7-b26687be": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-YhUIJHHGkqPgEcMYkPCKTyGUdoGKWtopIycQyjJH8OjvRgOYsXsaKehLVPScKJWAULPxMa4N1vCe6szREFlZ7A==",
        "name": "@babel/plugin-syntax-typescript",
        "url": "https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.16.7.tgz",
    },
    "@babel/template@7.16.7": {
        "deps": [
            {
                "id": "@babel/code-frame@7.16.7",
            },
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-I8j/x8kHUrbYRTUxXrrMbfCa7jxkE7tZre39x3kjr9hvI82cK1FfqLygotcWN5kdPGWcLdWMHpSBavse5tWw3w==",
        "name": "@babel/template",
        "url": "https://registry.npmjs.org/@babel/template/-/template-7.16.7.tgz",
    },
    "@babel/traverse@7.17.0": {
        "deps": [
            {
                "id": "@babel/code-frame@7.16.7",
            },
            {
                "id": "@babel/generator@7.17.0",
            },
            {
                "id": "@babel/helper-environment-visitor@7.16.7",
            },
            {
                "id": "@babel/helper-function-name@7.16.7",
            },
            {
                "id": "@babel/helper-hoist-variables@7.16.7",
            },
            {
                "id": "@babel/helper-split-export-declaration@7.16.7",
            },
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "globals@11.12.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-fpFIXvqD6kC7c7PUNnZ0Z8cQXlarCLtCUpt2S1Dx7PjoRtCFffvOkHHSom+m5HIxMZn5bIBVb71lhabcmjEsqg==",
        "name": "@babel/traverse",
        "url": "https://registry.npmjs.org/@babel/traverse/-/traverse-7.17.0.tgz",
    },
    "@babel/types@7.17.0": {
        "deps": [
            {
                "id": "@babel/helper-validator-identifier@7.16.7",
            },
            {
                "id": "to-fast-properties@2.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TmKSNO4D5rzhL5bjWFcVHHLETzfQ/AmbKpKPOSjlP0WoHZ6L911fgoOKY4Alp/emzG4cHJdyN49zpgkbXFEHHw==",
        "name": "@babel/types",
        "url": "https://registry.npmjs.org/@babel/types/-/types-7.17.0.tgz",
    },
    "@bcoe/v8-coverage@0.2.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0hYQ8SB4Db5zvZB4axdMHGwEaQjkZzFjQiN9LVYvIFB2nSUHW9tYpxWriPrWDASIxiaXax83REcLxuSdnGPZtw==",
        "name": "@bcoe/v8-coverage",
        "url": "https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz",
    },
    "@eslint/eslintrc@1.1.0": {
        "deps": [
            {
                "id": "ajv@6.12.6",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "espree@9.3.1",
            },
            {
                "id": "globals@13.12.1",
            },
            {
                "id": "ignore@4.0.6",
            },
            {
                "id": "import-fresh@3.3.0",
            },
            {
                "id": "js-yaml@4.1.0",
            },
            {
                "id": "minimatch@3.0.5",
            },
            {
                "id": "strip-json-comments@3.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-C1DfL7XX4nPqGd6jcP01W9pVM1HYCuUkFk1432D7F0v3JSlUIeOYn9oCoi3eoLZ+iwBSb29BMFxxny0YrrEZqg==",
        "name": "@eslint/eslintrc",
        "url": "https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-1.1.0.tgz",
    },
    "@gar/promisify@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-82cpyJyKRoQoRi+14ibCeGPu0CwypgtBAdBhq1WfvagpCZNKqwXbKwXllYSMG91DhmG4jt9gN8eP6lGOtozuaw==",
        "name": "@gar/promisify",
        "url": "https://registry.npmjs.org/@gar/promisify/-/promisify-1.1.2.tgz",
    },
    "@humanwhocodes/config-array@0.6.0": {
        "deps": [
            {
                "id": "@humanwhocodes/object-schema@1.2.1",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "minimatch@3.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JQlEKbcgEUjBFhLIF4iqM7u/9lwgHRBcpHrmUNCALK0Q3amXN6lxdoXLnF0sm11E9VqTmBALR87IlUg1bZ8A9A==",
        "name": "@humanwhocodes/config-array",
        "url": "https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.6.0.tgz",
    },
    "@humanwhocodes/object-schema@1.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZnQMnLV4e7hDlUvw8H+U8ASL02SS2Gn6+9Ac3wGGLIe7+je2AeAOxPY+izIPJDfFDb7eDjev0Us8MO1iFRN8hA==",
        "name": "@humanwhocodes/object-schema",
        "url": "https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz",
    },
    "@istanbuljs/load-nyc-config@1.1.0": {
        "deps": [
            {
                "id": "camelcase@5.3.1",
            },
            {
                "id": "find-up@4.1.0",
            },
            {
                "id": "get-package-type@0.1.0",
            },
            {
                "id": "js-yaml@3.14.1",
            },
            {
                "id": "resolve-from@5.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VjeHSlIzpv/NyD3N0YuHfXOPDIixcA1q2ZV98wsMqcYlPmv2n3Yb2lYP9XMElnaFVXg5A7YLTeLu6V84uQDjmQ==",
        "name": "@istanbuljs/load-nyc-config",
        "url": "https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz",
    },
    "@istanbuljs/schema@0.1.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZXRY4jNvVgSVQ8DL3LTcakaAtXwTVUxE81hslsyD2AtoXW/wVob10HkOJ1X/pAlcI7D+2YoZKg5do8G/w6RYgA==",
        "name": "@istanbuljs/schema",
        "url": "https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz",
    },
    "@jest/console@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-kZ/tNpS3NXn0mlXXXPNuDZnb4c0oZ20r4K5eemM2k30ZC3G0T02nXUvyhf5YdbXWHPEJLc9qGLxEZ216MdL+Zg==",
        "name": "@jest/console",
        "url": "https://registry.npmjs.org/@jest/console/-/console-27.5.1.tgz",
    },
    "@jest/core@27.5.1": {
        "deps": [
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/reporters@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "ansi-escapes@4.3.2",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "emittery@0.8.1",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-changed-files@27.5.1",
            },
            {
                "id": "jest-config@27.5.1",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-resolve-dependencies@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-runner@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "jest-watcher@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "rimraf@3.0.2",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AK6/UTrvQD0Cd24NSqmIA6rKsu0tKIxfiCducZvqxYdmMisOYAsdItspT+fQDQYARPf8XgjAFZi0ogW2agH5nQ==",
        "name": "@jest/core",
        "url": "https://registry.npmjs.org/@jest/core/-/core-27.5.1.tgz",
    },
    "@jest/core@27.5.1-70c2be6d": {
        "deps": [
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "ansi-escapes@4.3.2",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "emittery@0.8.1",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-changed-files@27.5.1",
            },
            {
                "id": "jest-config@27.5.1-1e8b1377",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-resolve-dependencies@27.5.1",
            },
            {
                "id": "jest-runner@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "jest-watcher@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "rimraf@3.0.2",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
        ],
        "extra_deps": {
            "@jest/core@27.5.1-70c2be6d": [
                {
                    "id": "@jest/reporters@27.5.1-1e8b1377",
                },
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "@jest/reporters@27.5.1-1e8b1377": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "jest-resolve@27.5.1": [
                {
                    "id": "jest-pnp-resolver@1.2.2-a0a4a415",
                },
            ],
            "jest-pnp-resolver@1.2.2-a0a4a415": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
        },
        "integrity": "sha512-AK6/UTrvQD0Cd24NSqmIA6rKsu0tKIxfiCducZvqxYdmMisOYAsdItspT+fQDQYARPf8XgjAFZi0ogW2agH5nQ==",
        "name": "@jest/core",
        "url": "https://registry.npmjs.org/@jest/core/-/core-27.5.1.tgz",
    },
    "@jest/environment@27.5.1": {
        "deps": [
            {
                "id": "@jest/fake-timers@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "jest-mock@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/WQjhPJe3/ghaol/4Bq480JKXV/Rfw8nQdN7f41fM8VDHLcxKXou6QyXAh3EFr9/bVG3x74z1NWDkP87EiY8gA==",
        "name": "@jest/environment",
        "url": "https://registry.npmjs.org/@jest/environment/-/environment-27.5.1.tgz",
    },
    "@jest/fake-timers@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@sinonjs/fake-timers@8.1.0",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-mock@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/aPowoolwa07k7/oM3aASneNeBGCmGQsc3ugN4u6s4C/+s5M64MFo/+djTdiwcbQlRfFElGuDXWzaWj6QgKObQ==",
        "name": "@jest/fake-timers",
        "url": "https://registry.npmjs.org/@jest/fake-timers/-/fake-timers-27.5.1.tgz",
    },
    "@jest/globals@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "expect@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZEJNB41OBQQgGzgyInAv0UUfDDj3upmHydjieSxFvTRuZElrx7tXg/uVQ5hYVEwiXs3+aMsAeEc9X7xiSKCm4Q==",
        "name": "@jest/globals",
        "url": "https://registry.npmjs.org/@jest/globals/-/globals-27.5.1.tgz",
    },
    "@jest/reporters@27.5.1": {
        "deps": [
            {
                "id": "@bcoe/v8-coverage@0.2.3",
            },
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "collect-v8-coverage@1.0.1",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "istanbul-lib-coverage@3.2.0",
            },
            {
                "id": "istanbul-lib-instrument@5.1.0",
            },
            {
                "id": "istanbul-lib-report@3.0.0",
            },
            {
                "id": "istanbul-lib-source-maps@4.0.1",
            },
            {
                "id": "istanbul-reports@3.1.4",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "source-map@0.6.1",
            },
            {
                "id": "string-length@4.0.2",
            },
            {
                "id": "terminal-link@2.1.1",
            },
            {
                "id": "v8-to-istanbul@8.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cPXh9hWIlVJMQkVk84aIvXuBB4uQQmFqZiacloFuGiP3ah1sbCxCosidXFDfqG8+6fO1oR2dTJTlsOy4VFmUfw==",
        "name": "@jest/reporters",
        "url": "https://registry.npmjs.org/@jest/reporters/-/reporters-27.5.1.tgz",
    },
    "@jest/reporters@27.5.1-1e8b1377": {
        "deps": [
            {
                "id": "@bcoe/v8-coverage@0.2.3",
            },
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "collect-v8-coverage@1.0.1",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "istanbul-lib-coverage@3.2.0",
            },
            {
                "id": "istanbul-lib-instrument@5.1.0",
            },
            {
                "id": "istanbul-lib-report@3.0.0",
            },
            {
                "id": "istanbul-lib-source-maps@4.0.1",
            },
            {
                "id": "istanbul-reports@3.1.4",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "source-map@0.6.1",
            },
            {
                "id": "string-length@4.0.2",
            },
            {
                "id": "terminal-link@2.1.1",
            },
            {
                "id": "v8-to-istanbul@8.1.1",
            },
        ],
        "extra_deps": {
            "@jest/core@27.5.1-70c2be6d": [
                {
                    "id": "@jest/reporters@27.5.1-1e8b1377",
                },
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "@jest/reporters@27.5.1-1e8b1377": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "jest-resolve@27.5.1": [
                {
                    "id": "jest-pnp-resolver@1.2.2-a0a4a415",
                },
            ],
            "jest-pnp-resolver@1.2.2-a0a4a415": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
        },
        "integrity": "sha512-cPXh9hWIlVJMQkVk84aIvXuBB4uQQmFqZiacloFuGiP3ah1sbCxCosidXFDfqG8+6fO1oR2dTJTlsOy4VFmUfw==",
        "name": "@jest/reporters",
        "url": "https://registry.npmjs.org/@jest/reporters/-/reporters-27.5.1.tgz",
    },
    "@jest/source-map@27.5.1": {
        "deps": [
            {
                "id": "callsites@3.1.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "source-map@0.6.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-y9NIHUYF3PJRlHk98NdC/N1gl88BL08aQQgu4k4ZopQkCw9t9cV8mtl3TV8b/YCB8XaVTFrmUTAJvjsntDireg==",
        "name": "@jest/source-map",
        "url": "https://registry.npmjs.org/@jest/source-map/-/source-map-27.5.1.tgz",
    },
    "@jest/test-result@27.5.1": {
        "deps": [
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/istanbul-lib-coverage@2.0.4",
            },
            {
                "id": "collect-v8-coverage@1.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EW35l2RYFUcUQxFJz5Cv5MTOxlJIQs4I7gxzi2zVU7PJhOwfYq1MdC5nhSmYjX1gmMmLPvB3sIaC+BkcHRBfag==",
        "name": "@jest/test-result",
        "url": "https://registry.npmjs.org/@jest/test-result/-/test-result-27.5.1.tgz",
    },
    "@jest/test-sequencer@27.5.1": {
        "deps": [
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LCheJF7WB2+9JuCS7VB/EmGIdQuhtqjRNI9A43idHv3E4KltCTsPsLxvdaubFHSYwY/fNjMWjl6vNRhDiN7vpQ==",
        "name": "@jest/test-sequencer",
        "url": "https://registry.npmjs.org/@jest/test-sequencer/-/test-sequencer-27.5.1.tgz",
    },
    "@jest/transform@27.5.1": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "babel-plugin-istanbul@6.1.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "convert-source-map@1.8.0",
            },
            {
                "id": "fast-json-stable-stringify@2.1.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "pirates@4.0.5",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "source-map@0.6.1",
            },
            {
                "id": "write-file-atomic@3.0.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ipON6WtYgl/1329g5AIJVbUuEh0wZVbdpGwC99Jw4LwuoBNS95MVphU6zOeD9pDkon+LLbFL7lOQRapbB8SCHw==",
        "name": "@jest/transform",
        "url": "https://registry.npmjs.org/@jest/transform/-/transform-27.5.1.tgz",
    },
    "@jest/types@27.4.2": {
        "deps": [
            {
                "id": "@types/istanbul-lib-coverage@2.0.4",
            },
            {
                "id": "@types/istanbul-reports@3.0.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "@types/yargs@16.0.4",
            },
            {
                "id": "chalk@4.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-j35yw0PMTPpZsUoOBiuHzr1zTYoad1cVIE0ajEjcrJONxxrko/IRGKkXx3os0Nsi4Hu3+5VmDbVfq5WhG/pWAg==",
        "name": "@jest/types",
        "url": "https://registry.npmjs.org/@jest/types/-/types-27.4.2.tgz",
    },
    "@jest/types@27.5.1": {
        "deps": [
            {
                "id": "@types/istanbul-lib-coverage@2.0.4",
            },
            {
                "id": "@types/istanbul-reports@3.0.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "@types/yargs@16.0.4",
            },
            {
                "id": "chalk@4.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Cx46iJ9QpwQTjIdq5VJu2QTMMs3QlEjI0x1QbBP5W1+nMzyc2XmimiRR/CbX9TO0cPTeUlxWMOu8mslYsJ8DEw==",
        "name": "@jest/types",
        "url": "https://registry.npmjs.org/@jest/types/-/types-27.5.1.tgz",
    },
    "@jridgewell/resolve-uri@3.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VPeQ7+wH0itvQxnG+lIzWgkysKIr3L9sslimFW55rHMdGu/qCQ5z5h9zq4gI8uBtqkpHhsF4Z/OwExufUCThew==",
        "name": "@jridgewell/resolve-uri",
        "url": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.0.5.tgz",
    },
    "@jridgewell/sourcemap-codec@1.4.11": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Fg32GrJo61m+VqYSdRSjRXMjQ06j8YIYfcTqndLYVAaHmroZHLJZCydsWBOTDqXS2v+mjxohBWEMfg97GXmYQg==",
        "name": "@jridgewell/sourcemap-codec",
        "url": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.11.tgz",
    },
    "@jridgewell/trace-mapping@0.3.4": {
        "deps": [
            {
                "id": "@jridgewell/resolve-uri@3.0.5",
            },
            {
                "id": "@jridgewell/sourcemap-codec@1.4.11",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vFv9ttIedivx0ux3QSjhgtCVjPZd5l46ZOMDSCwnH1yUO2e964gO8LZGyv2QkqcgR6TnBU1v+1IFqmeoG+0UJQ==",
        "name": "@jridgewell/trace-mapping",
        "url": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.4.tgz",
    },
    "@npmcli/fs@1.1.1": {
        "deps": [
            {
                "id": "@gar/promisify@1.1.2",
            },
            {
                "id": "semver@7.3.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8KG5RD0GVP4ydEzRn/I4BNDuxDtqVbOdm8675T49OIG/NGhaK0pjPX7ZcDlvKYbA+ulvVK3ztfcF4uBdOxuJbQ==",
        "name": "@npmcli/fs",
        "url": "https://registry.npmjs.org/@npmcli/fs/-/fs-1.1.1.tgz",
    },
    "@npmcli/move-file@1.1.2": {
        "deps": [
            {
                "id": "mkdirp@1.0.4",
            },
            {
                "id": "rimraf@3.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1SUf/Cg2GzGDyaf15aR9St9TWlb+XvbZXWpDx8YKs7MLzMH/BCeopv+y9vzrzgkfykCGuWOlSu3mZhj2+FQcrg==",
        "name": "@npmcli/move-file",
        "url": "https://registry.npmjs.org/@npmcli/move-file/-/move-file-1.1.2.tgz",
    },
    "@protobufjs/aspromise@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-AEGHi4IJ8vpLzF4GZjVevJb/l/NgwwVP/oPbt47hwRk=",
        "name": "@protobufjs/aspromise",
        "url": "https://registry.npmjs.org/@protobufjs/aspromise/-/aspromise-1.1.2.tgz",
    },
    "@protobufjs/base64@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AZkcAA5vnN/v4PDqKyMR5lx7hZttPDgClv83E//FMNhR2TMcLUhfRUBHCmSl0oi9zMgDDqRUJkSxO3wm85+XLg==",
        "name": "@protobufjs/base64",
        "url": "https://registry.npmjs.org/@protobufjs/base64/-/base64-1.1.2.tgz",
    },
    "@protobufjs/codegen@2.0.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-YyFaikqM5sH0ziFZCN3xDC7zeGaB/d0IUb9CATugHWbd1FRFwWwt4ld4OYMPWu5a3Xe01mGAULCdqhMlPl29Jg==",
        "name": "@protobufjs/codegen",
        "url": "https://registry.npmjs.org/@protobufjs/codegen/-/codegen-2.0.4.tgz",
    },
    "@protobufjs/eventemitter@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-UilS7V7SU5ujjKl+9JguaLnEv2ySbxUVUsfsTMFYcxE=",
        "name": "@protobufjs/eventemitter",
        "url": "https://registry.npmjs.org/@protobufjs/eventemitter/-/eventemitter-1.1.0.tgz",
    },
    "@protobufjs/fetch@1.1.0": {
        "deps": [
            {
                "id": "@protobufjs/aspromise@1.1.2",
            },
            {
                "id": "@protobufjs/inquire@1.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-YGayocSE7VpWrvkFKivdb11GZ5vKrRgTSfRWESfskms=",
        "name": "@protobufjs/fetch",
        "url": "https://registry.npmjs.org/@protobufjs/fetch/-/fetch-1.1.0.tgz",
    },
    "@protobufjs/float@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-ILPWEtUygbdUYC1SqOam4JAyFp1TmeUV9vXot9PecS0=",
        "name": "@protobufjs/float",
        "url": "https://registry.npmjs.org/@protobufjs/float/-/float-1.0.2.tgz",
    },
    "@protobufjs/inquire@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-YRz7gUmvLxHfO3mBlH24Hf1naCMUJ70kpFfKAXUjVrk=",
        "name": "@protobufjs/inquire",
        "url": "https://registry.npmjs.org/@protobufjs/inquire/-/inquire-1.1.0.tgz",
    },
    "@protobufjs/path@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-zDZO6RAXPDbVc0U1ortTuOfobS0hnychgVirPz3KMow=",
        "name": "@protobufjs/path",
        "url": "https://registry.npmjs.org/@protobufjs/path/-/path-1.1.2.tgz",
    },
    "@protobufjs/pool@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-9yHb0nKC0sfRwr8a6fegPMPvnPiC/kaaMsFNHa5zJwM=",
        "name": "@protobufjs/pool",
        "url": "https://registry.npmjs.org/@protobufjs/pool/-/pool-1.1.0.tgz",
    },
    "@protobufjs/utf8@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-HGBvTAvK5elmEG+C6oEHZttrfEqXHufnhDQ5itkjDSQ=",
        "name": "@protobufjs/utf8",
        "url": "https://registry.npmjs.org/@protobufjs/utf8/-/utf8-1.1.0.tgz",
    },
    "@rollup/plugin-commonjs@16.0.0": {
        "deps": [
            {
                "id": "@rollup/pluginutils@3.1.0",
            },
            {
                "id": "commondir@1.0.1",
            },
            {
                "id": "estree-walker@2.0.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "is-reference@1.2.1",
            },
            {
                "id": "magic-string@0.25.7",
            },
            {
                "id": "resolve@1.22.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LuNyypCP3msCGVQJ7ki8PqYdpjfEkE/xtFa5DqlF+7IBD0JsfMZ87C58heSwIMint58sAUZbt3ITqOmdQv/dXw==",
        "name": "@rollup/plugin-commonjs",
        "url": "https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-16.0.0.tgz",
    },
    "@rollup/plugin-commonjs@16.0.0-dc3fc578": {
        "deps": [
            {
                "id": "@rollup/pluginutils@3.1.0-db11f6fd",
            },
            {
                "id": "commondir@1.0.1",
            },
            {
                "id": "estree-walker@2.0.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "is-reference@1.2.1",
            },
            {
                "id": "magic-string@0.25.7",
            },
            {
                "id": "resolve@1.22.0",
            },
            {
                "id": "rollup@2.58.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LuNyypCP3msCGVQJ7ki8PqYdpjfEkE/xtFa5DqlF+7IBD0JsfMZ87C58heSwIMint58sAUZbt3ITqOmdQv/dXw==",
        "name": "@rollup/plugin-commonjs",
        "url": "https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-16.0.0.tgz",
    },
    "@rollup/plugin-node-resolve@13.0.4": {
        "deps": [
            {
                "id": "@rollup/pluginutils@3.1.0",
            },
            {
                "id": "@types/resolve@1.17.1",
            },
            {
                "id": "builtin-modules@3.2.0",
            },
            {
                "id": "deepmerge@4.2.2",
            },
            {
                "id": "is-module@1.0.0",
            },
            {
                "id": "resolve@1.22.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eYq4TFy40O8hjeDs+sIxEH/jc9lyuI2k9DM557WN6rO5OpnC2qXMBNj4IKH1oHrnAazL49C5p0tgP0/VpqJ+/w==",
        "name": "@rollup/plugin-node-resolve",
        "url": "https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-13.0.4.tgz",
    },
    "@rollup/plugin-node-resolve@13.0.4-dc3fc578": {
        "deps": [
            {
                "id": "@rollup/pluginutils@3.1.0-db11f6fd",
            },
            {
                "id": "@types/resolve@1.17.1",
            },
            {
                "id": "builtin-modules@3.2.0",
            },
            {
                "id": "deepmerge@4.2.2",
            },
            {
                "id": "is-module@1.0.0",
            },
            {
                "id": "resolve@1.22.0",
            },
            {
                "id": "rollup@2.58.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eYq4TFy40O8hjeDs+sIxEH/jc9lyuI2k9DM557WN6rO5OpnC2qXMBNj4IKH1oHrnAazL49C5p0tgP0/VpqJ+/w==",
        "name": "@rollup/plugin-node-resolve",
        "url": "https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-13.0.4.tgz",
    },
    "@rollup/pluginutils@3.1.0": {
        "deps": [
            {
                "id": "@types/estree@0.0.39",
            },
            {
                "id": "estree-walker@1.0.1",
            },
            {
                "id": "picomatch@2.3.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GksZ6pr6TpIjHm8h9lSQ8pi8BE9VeubNT0OMJ3B5uZJ8pz73NPiqOtCog/x2/QzM1ENChPKxMDhiQuRHsqc+lg==",
        "name": "@rollup/pluginutils",
        "url": "https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-3.1.0.tgz",
    },
    "@rollup/pluginutils@3.1.0-db11f6fd": {
        "deps": [
            {
                "id": "@types/estree@0.0.39",
            },
            {
                "id": "estree-walker@1.0.1",
            },
            {
                "id": "picomatch@2.3.1",
            },
            {
                "id": "rollup@2.58.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GksZ6pr6TpIjHm8h9lSQ8pi8BE9VeubNT0OMJ3B5uZJ8pz73NPiqOtCog/x2/QzM1ENChPKxMDhiQuRHsqc+lg==",
        "name": "@rollup/pluginutils",
        "url": "https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-3.1.0.tgz",
    },
    "@sinonjs/commons@1.8.3": {
        "deps": [
            {
                "id": "type-detect@4.0.8",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xkNcLAn/wZaX14RPlwizcKicDk9G3F8m2nU3L7Ukm5zBgTwiT0wsoFAHx9Jq56fJA1z/7uKGtCRu16sOUCLIHQ==",
        "name": "@sinonjs/commons",
        "url": "https://registry.npmjs.org/@sinonjs/commons/-/commons-1.8.3.tgz",
    },
    "@sinonjs/fake-timers@8.1.0": {
        "deps": [
            {
                "id": "@sinonjs/commons@1.8.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OAPJUAtgeINhh/TAlUID4QTs53Njm7xzddaVlEs/SXwgtiD1tW22zAB/W1wdqfrpmikgaWQ9Fw6Ws+hsiRm5Vg==",
        "name": "@sinonjs/fake-timers",
        "url": "https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-8.1.0.tgz",
    },
    "@tootallnate/once@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RbzJvlNzmRq5c3O09UipeuXno4tA1FE6ikOjxZK0tuxVv3412l64l5t1W5pj4+rJq9vpkm/kwiR07aZXnsKPxw==",
        "name": "@tootallnate/once",
        "url": "https://registry.npmjs.org/@tootallnate/once/-/once-1.1.2.tgz",
    },
    "@types/argparse@2.0.10": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-C4wahC3gz3vQtvPazrJ5ONwmK1zSDllQboiWvpMM/iOswCYfBREFnjFbq/iWKIVOCl8+m5Pk6eva6/ZSsDuIGA==",
        "name": "@types/argparse",
        "url": "https://registry.npmjs.org/@types/argparse/-/argparse-2.0.10.tgz",
    },
    "@types/babel__core@7.1.18": {
        "deps": [
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "@types/babel__generator@7.6.4",
            },
            {
                "id": "@types/babel__template@7.4.1",
            },
            {
                "id": "@types/babel__traverse@7.14.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-S7unDjm/C7z2A2R9NzfKCK1I+BAALDtxEmsJBwlB3EzNfb929ykjL++1CK9LO++EIp2fQrC8O+BwjKvz6UeDyQ==",
        "name": "@types/babel__core",
        "url": "https://registry.npmjs.org/@types/babel__core/-/babel__core-7.1.18.tgz",
    },
    "@types/babel__generator@7.6.4": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tFkciB9j2K755yrTALxD44McOrk+gfpIpvC3sxHjRawj6PfnQxrse4Clq5y/Rq+G3mrBurMax/lG8Qn2t9mSsg==",
        "name": "@types/babel__generator",
        "url": "https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.4.tgz",
    },
    "@types/babel__template@7.4.1": {
        "deps": [
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-azBFKemX6kMg5Io+/rdGT0dkGreboUVR0Cdm3fz9QJWpaQGJRQXl7C+6hOTCZcMll7KFyEQpgbYI2lHdsS4U7g==",
        "name": "@types/babel__template",
        "url": "https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.1.tgz",
    },
    "@types/babel__traverse@7.14.2": {
        "deps": [
            {
                "id": "@babel/types@7.17.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-K2waXdXBi2302XUdcHcR1jCeU0LL4TD9HRs/gk0N2Xvrht+G/BfJa4QObBQZfhMdxiCpV3COl5Nfq4uKTeTnJA==",
        "name": "@types/babel__traverse",
        "url": "https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.14.2.tgz",
    },
    "@types/eslint-scope@3.7.3": {
        "deps": [
            {
                "id": "@types/eslint@8.4.1",
            },
            {
                "id": "@types/estree@0.0.51",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-PB3ldyrcnAicT35TWPs5IcwKD8S333HMaa2VVv4+wdvebJkjWuW/xESoB8IwRcog8HYVYamb1g/R31Qv5Bx03g==",
        "name": "@types/eslint-scope",
        "url": "https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.3.tgz",
    },
    "@types/eslint@7.28.2": {
        "deps": [
            {
                "id": "@types/estree@0.0.51",
            },
            {
                "id": "@types/json-schema@7.0.9",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KubbADPkfoU75KgKeKLsFHXnU4ipH7wYg0TRT33NK3N3yiu7jlFAAoygIWBV+KbuHx/G+AvuGX6DllnK35gfJA==",
        "name": "@types/eslint",
        "url": "https://registry.npmjs.org/@types/eslint/-/eslint-7.28.2.tgz",
    },
    "@types/eslint@8.4.1": {
        "deps": [
            {
                "id": "@types/estree@0.0.51",
            },
            {
                "id": "@types/json-schema@7.0.9",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GE44+DNEyxxh2Kc6ro/VkIj+9ma0pO0bwv9+uHSyBrikYOHr8zYcdPvnBOp1aw8s+CjRvuSx7CyWqRrNFQ59mA==",
        "name": "@types/eslint",
        "url": "https://registry.npmjs.org/@types/eslint/-/eslint-8.4.1.tgz",
    },
    "@types/estree@0.0.39": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EYNwp3bU+98cpU4lAWYYL7Zz+2gryWH1qbdDTidVd6hkiR6weksdbMadyXKXNPEkQFhXM+hVO9ZygomHXp+AIw==",
        "name": "@types/estree",
        "url": "https://registry.npmjs.org/@types/estree/-/estree-0.0.39.tgz",
    },
    "@types/estree@0.0.50": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-C6N5s2ZFtuZRj54k2/zyRhNDjJwwcViAM3Nbm8zjBpbqAdZ00mr0CFxvSKeO8Y/e03WVFLpQMdHYVfUd6SB+Hw==",
        "name": "@types/estree",
        "url": "https://registry.npmjs.org/@types/estree/-/estree-0.0.50.tgz",
    },
    "@types/estree@0.0.51": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-CuPgU6f3eT/XgKKPqKd/gLZV1Xmvf1a2R5POBOGQa6uv82xpls89HU5zKeVoyR8XzHd1RGNOlQlvUe3CFkjWNQ==",
        "name": "@types/estree",
        "url": "https://registry.npmjs.org/@types/estree/-/estree-0.0.51.tgz",
    },
    "@types/graceful-fs@4.1.5": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-anKkLmZZ+xm4p8JWBf4hElkM4XR+EZeA2M9BAkkTldmcyDY4mbdIJnRghDJH3Ov5ooY7/UAoENtmdMSkaAd7Cw==",
        "name": "@types/graceful-fs",
        "url": "https://registry.npmjs.org/@types/graceful-fs/-/graceful-fs-4.1.5.tgz",
    },
    "@types/istanbul-lib-coverage@2.0.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-z/QT1XN4K4KYuslS23k62yDIDLwLFkzxOuMplDtObz0+y7VqJCaO2o+SPwHCvLFZh7xazvvoor2tA/hPz9ee7g==",
        "name": "@types/istanbul-lib-coverage",
        "url": "https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.4.tgz",
    },
    "@types/istanbul-lib-report@3.0.0": {
        "deps": [
            {
                "id": "@types/istanbul-lib-coverage@2.0.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-plGgXAPfVKFoYfa9NpYDAkseG+g6Jr294RqeqcqDixSbU34MZVJRi/P+7Y8GDpzkEwLaGZZOpKIEmeVZNtKsrg==",
        "name": "@types/istanbul-lib-report",
        "url": "https://registry.npmjs.org/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz",
    },
    "@types/istanbul-reports@3.0.1": {
        "deps": [
            {
                "id": "@types/istanbul-lib-report@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-c3mAZEuK0lvBp8tmuL74XRKn1+y2dcwOUpH7x4WrF6gk1GIgiluDRgMYQtw2OFcBvAJWlt6ASU3tSqxp0Uu0Aw==",
        "name": "@types/istanbul-reports",
        "url": "https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz",
    },
    "@types/json-schema@7.0.9": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qcUXuemtEu+E5wZSJHNxUXeCZhAfXKQ41D+duX+VYPde7xyEVZci+/oXKJL13tnRs9lR2pr4fod59GT6/X1/yQ==",
        "name": "@types/json-schema",
        "url": "https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.9.tgz",
    },
    "@types/long@4.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5tXH6Bx/kNGd3MgffdmP4dy2Z+G4eaXw0SE81Tq3BNadtnMR5/ySMzX4SLEzHJzSmPNn4HIdpQsBvXMUykr58w==",
        "name": "@types/long",
        "url": "https://registry.npmjs.org/@types/long/-/long-4.0.1.tgz",
    },
    "@types/node-fetch@2.5.12": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "form-data@3.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-MKgC4dlq4kKNa/mYrwpKfzQMB5X3ee5U6fSprkKpToBqBmX4nFZL9cW5jl6sWn+xpRJ7ypWh2yyqqr8UUCstSw==",
        "name": "@types/node-fetch",
        "url": "https://registry.npmjs.org/@types/node-fetch/-/node-fetch-2.5.12.tgz",
    },
    "@types/node@16.11.24": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Ezv33Rl4mIi6YdSHfIRNBd4Q9kUe5okiaw/ikvJiJDmuQZNW5kfdg7+oQPF8NO6sTcr3woIpj3jANzTXdvEZXA==",
        "name": "@types/node",
        "url": "https://registry.npmjs.org/@types/node/-/node-16.11.24.tgz",
    },
    "@types/node@17.0.17": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-e8PUNQy1HgJGV3iU/Bp2+D/DXh3PYeyli8LgIwsQcs1Ar1LoaWHSIT6Rw+H2rNJmiq6SNWiDytfx8+gYj7wDHw==",
        "name": "@types/node",
        "url": "https://registry.npmjs.org/@types/node/-/node-17.0.17.tgz",
    },
    "@types/object-hash@1.3.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xFdpkAkikBgqBdG9vIlsqffDV8GpvnPEzs0IUtr1v3BEB97ijsFQ4RXVbUZwjFThhB4MDSTUfvmxUD5PGx0wXA==",
        "name": "@types/object-hash",
        "url": "https://registry.npmjs.org/@types/object-hash/-/object-hash-1.3.4.tgz",
    },
    "@types/prettier@2.4.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ReVR2rLTV1kvtlWFyuot+d1pkpG2Fw/XKE3PDAdj57rbM97ttSp9JZ2UsP+2EHTylra9cUf6JA7tGwW1INzUrA==",
        "name": "@types/prettier",
        "url": "https://registry.npmjs.org/@types/prettier/-/prettier-2.4.4.tgz",
    },
    "@types/resolve@1.17.1": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yy7HuzQhj0dhGpD8RLXSZWEkLsV9ibvxvi6EiJ3bkqLAO1RGo0WbkWQiwpRlSFymTJRz0d3k5LM3kkx8ArDbLw==",
        "name": "@types/resolve",
        "url": "https://registry.npmjs.org/@types/resolve/-/resolve-1.17.1.tgz",
    },
    "@types/stack-utils@2.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Hl219/BT5fLAaz6NDkSuhzasy49dwQS/DSdu4MdggFB8zcXv7vflBI3xp7FEmkmdDkBUI2bPUNeMttp2knYdxw==",
        "name": "@types/stack-utils",
        "url": "https://registry.npmjs.org/@types/stack-utils/-/stack-utils-2.0.1.tgz",
    },
    "@types/tar-stream@2.2.2": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1AX+Yt3icFuU6kxwmPakaiGrJUwG44MpuiqPg4dSolRFk6jmvs4b3IbUol9wKDLIgU76gevn3EwE8y/DkSJCZQ==",
        "name": "@types/tar-stream",
        "url": "https://registry.npmjs.org/@types/tar-stream/-/tar-stream-2.2.2.tgz",
    },
    "@types/yargs-parser@20.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7tFImggNeNBVMsn0vLrpn1H1uPrUBdnARPTpZoitY37ZrdJREzf7I16tMrlK3hen349gr1NYh8CmZQa7CTG6Aw==",
        "name": "@types/yargs-parser",
        "url": "https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-20.2.1.tgz",
    },
    "@types/yargs@16.0.4": {
        "deps": [
            {
                "id": "@types/yargs-parser@20.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-T8Yc9wt/5LbJyCaLiHPReJa0kApcIgJ7Bn735GjItUfh08Z1pJvu8QZqb9s+mMvKV6WUQRV7K2R46YbjMXTTJw==",
        "name": "@types/yargs",
        "url": "https://registry.npmjs.org/@types/yargs/-/yargs-16.0.4.tgz",
    },
    "@webassemblyjs/ast@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/helper-numbers@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-bytecode@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ukBh14qFLjxTQNTXocdyksN5QdM28S1CxHt2rdskFyL+xFV7VremuBLVbmCePj+URalXBENx/9Lm7lnhihtCSw==",
        "name": "@webassemblyjs/ast",
        "url": "https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.11.1.tgz",
    },
    "@webassemblyjs/floating-point-hex-parser@1.11.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-iGRfyc5Bq+NnNuX8b5hwBrRjzf0ocrJPI6GWFodBFzmFnyvrQ83SHKhmilCU/8Jv67i4GJZBMhEzltxzcNagtQ==",
        "name": "@webassemblyjs/floating-point-hex-parser",
        "url": "https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.1.tgz",
    },
    "@webassemblyjs/helper-api-error@1.11.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RlhS8CBCXfRUR/cwo2ho9bkheSXG0+NwooXcc3PAILALf2QLdFyj7KGsKRbVc95hZnhnERon4kW/D3SZpp6Tcg==",
        "name": "@webassemblyjs/helper-api-error",
        "url": "https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.1.tgz",
    },
    "@webassemblyjs/helper-buffer@1.11.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-gwikF65aDNeeXa8JxXa2BAk+REjSyhrNC9ZwdT0f8jc4dQQeDQ7G4m0f2QCLPJiMTTO6wfDmRmj/pW0PsUvIcA==",
        "name": "@webassemblyjs/helper-buffer",
        "url": "https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.1.tgz",
    },
    "@webassemblyjs/helper-numbers@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/floating-point-hex-parser@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-api-error@1.11.1",
            },
            {
                "id": "@xtuc/long@4.2.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vDkbxiB8zfnPdNK9Rajcey5C0w+QJugEglN0of+kmO8l7lDb77AnlKYQF7aarZuCrv+l0UvqL+68gSDr3k9LPQ==",
        "name": "@webassemblyjs/helper-numbers",
        "url": "https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.1.tgz",
    },
    "@webassemblyjs/helper-wasm-bytecode@1.11.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-PvpoOGiJwXeTrSf/qfudJhwlvDQxFgelbMqtq52WWiXC6Xgg1IREdngmPN3bs4RoO83PnL/nFrxucXj1+BX62Q==",
        "name": "@webassemblyjs/helper-wasm-bytecode",
        "url": "https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.1.tgz",
    },
    "@webassemblyjs/helper-wasm-section@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-buffer@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-bytecode@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-gen@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-10P9No29rYX1j7F3EVPX3JvGPQPae+AomuSTPiF9eBQeChHI6iqjMIwR9JmOJXwpnn/oVGDk7I5IlskuMwU/pg==",
        "name": "@webassemblyjs/helper-wasm-section",
        "url": "https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.1.tgz",
    },
    "@webassemblyjs/ieee754@1.11.1": {
        "deps": [
            {
                "id": "@xtuc/ieee754@1.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hJ87QIPtAMKbFq6CGTkZYJivEwZDbQUgYd3qKSadTNOhVY7p+gfP6Sr0lLRVTaG1JjFj+r3YchoqRYxNH3M0GQ==",
        "name": "@webassemblyjs/ieee754",
        "url": "https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.1.tgz",
    },
    "@webassemblyjs/leb128@1.11.1": {
        "deps": [
            {
                "id": "@xtuc/long@4.2.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-BJ2P0hNZ0u+Th1YZXJpzW6miwqQUGcIHT1G/sf72gLVD9DZ5AdYTqPNbHZh6K1M5VmKvFXwGSWZADz+qBWxeRw==",
        "name": "@webassemblyjs/leb128",
        "url": "https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.1.tgz",
    },
    "@webassemblyjs/utf8@1.11.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9kqcxAEdMhiwQkHpkNiorZzqpGrodQQ2IGrHHxCy+Ozng0ofyMA0lTqiLkVs1uzTRejX+/O0EOT7KxqVPuXosQ==",
        "name": "@webassemblyjs/utf8",
        "url": "https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.1.tgz",
    },
    "@webassemblyjs/wasm-edit@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-buffer@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-bytecode@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-section@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-gen@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-opt@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-parser@1.11.1",
            },
            {
                "id": "@webassemblyjs/wast-printer@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-g+RsupUC1aTHfR8CDgnsVRVZFJqdkFHpsHMfJuWQzWU3tvnLC07UqHICfP+4XyL2tnr1amvl1Sdp06TnYCmVkA==",
        "name": "@webassemblyjs/wasm-edit",
        "url": "https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.1.tgz",
    },
    "@webassemblyjs/wasm-gen@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-bytecode@1.11.1",
            },
            {
                "id": "@webassemblyjs/ieee754@1.11.1",
            },
            {
                "id": "@webassemblyjs/leb128@1.11.1",
            },
            {
                "id": "@webassemblyjs/utf8@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-F7QqKXwwNlMmsulj6+O7r4mmtAlCWfO/0HdgOxSklZfQcDu0TpLiD1mRt/zF25Bk59FIjEuGAIyn5ei4yMfLhA==",
        "name": "@webassemblyjs/wasm-gen",
        "url": "https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.1.tgz",
    },
    "@webassemblyjs/wasm-opt@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-buffer@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-gen@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-parser@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VqnkNqnZlU5EB64pp1l7hdm3hmQw7Vgqa0KF/KCNO9sIpI6Fk6brDEiX+iCOYrvMuBWDws0NkTOxYEb85XQHHw==",
        "name": "@webassemblyjs/wasm-opt",
        "url": "https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.1.tgz",
    },
    "@webassemblyjs/wasm-parser@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-api-error@1.11.1",
            },
            {
                "id": "@webassemblyjs/helper-wasm-bytecode@1.11.1",
            },
            {
                "id": "@webassemblyjs/ieee754@1.11.1",
            },
            {
                "id": "@webassemblyjs/leb128@1.11.1",
            },
            {
                "id": "@webassemblyjs/utf8@1.11.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rrBujw+dJu32gYB7/Lup6UhdkPx9S9SnobZzRVL7VcBH9Bt9bCBLEuX/YXOOtBsOZ4NQrRykKhffRWHvigQvOA==",
        "name": "@webassemblyjs/wasm-parser",
        "url": "https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.1.tgz",
    },
    "@webassemblyjs/wast-printer@1.11.1": {
        "deps": [
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@xtuc/long@4.2.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-IQboUWM4eKzWW+N/jij2sRatKMh99QEelo3Eb2q0qXkvPRISAj8Qxtmw5itwqK+TTkBuUIE45AxYPToqPtL5gg==",
        "name": "@webassemblyjs/wast-printer",
        "url": "https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.11.1.tgz",
    },
    "@xtuc/ieee754@1.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-DX8nKgqcGwsc0eJSqYt5lwP4DH5FlHnmuWWBRy7X0NcaGR0ZtuyeESgMwTYVEtxmsNGY+qit4QYT/MIYTOTPeA==",
        "name": "@xtuc/ieee754",
        "url": "https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz",
    },
    "@xtuc/long@4.2.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-NuHqBY1PB/D8xU6s/thBgOAiAP7HOYDQ32+BFZILJ8ivkUkAHQnWfn6WhL79Owj1qmUnoN/YPhktdIoucipkAQ==",
        "name": "@xtuc/long",
        "url": "https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz",
    },
    "@yarnpkg/cli-dist@3.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7R8UUelyaGkpiSEgDgeK4A8jEUNmKw+un4UCY0xQoFXBJgVWS6lyWWN57FSs+3ybHZuNrEzaEa9+Bb5hiktGug==",
        "name": "@yarnpkg/cli-dist",
        "url": "https://registry.npmjs.org/@yarnpkg/cli-dist/-/cli-dist-3.1.1.tgz",
    },
    "abab@2.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9IK9EadsbHo6jLWIpxpR6pL0sazTXV6+SQv25ZB+F7Bj9mJNaOc4nCRabwd5M/JwmUa8idz6Eci6eKfJryPs6Q==",
        "name": "abab",
        "url": "https://registry.npmjs.org/abab/-/abab-2.0.5.tgz",
    },
    "abbrev@1.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-nne9/IiQ/hzIhY6pdDnbBtz7DjPTKrY00P/zvPSm5pOFkl6xuGrGnXn/VtTNNfNtAfZ9/1RtehkszU9qcTii0Q==",
        "name": "abbrev",
        "url": "https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz",
    },
    "acorn-globals@6.0.0": {
        "deps": [
            {
                "id": "acorn-walk@7.2.0",
            },
            {
                "id": "acorn@7.4.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZQl7LOWaF5ePqqcX4hLuv/bLXYQNfNWw2c0/yX/TsPRKamzHcTGQnlCjHT3TsmkOUVEPS3crCxiPfdzE/Trlhg==",
        "name": "acorn-globals",
        "url": "https://registry.npmjs.org/acorn-globals/-/acorn-globals-6.0.0.tgz",
    },
    "acorn-import-assertions@1.8.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-m7VZ3jwz4eK6A4Vtt8Ew1/mNbP24u0FhdyfA7fSvnJR6LMdfOYnmuIrrJAgrYfYJ10F/otaHTtrtrtmHdMNzEw==",
        "name": "acorn-import-assertions",
        "url": "https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.8.0.tgz",
    },
    "acorn-import-assertions@1.8.0-e30e60ed": {
        "deps": [
            {
                "id": "acorn@8.7.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-m7VZ3jwz4eK6A4Vtt8Ew1/mNbP24u0FhdyfA7fSvnJR6LMdfOYnmuIrrJAgrYfYJ10F/otaHTtrtrtmHdMNzEw==",
        "name": "acorn-import-assertions",
        "url": "https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.8.0.tgz",
    },
    "acorn-jsx@5.3.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rq9s+JNhf0IChjtDXxllJ7g41oZk5SlXtp0LHwyA5cejwn7vKmKp4pPri6YEePv2PU65sAsegbXtIinmDFDXgQ==",
        "name": "acorn-jsx",
        "url": "https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz",
    },
    "acorn-jsx@5.3.2-0c9e34c3": {
        "deps": [
            {
                "id": "acorn@8.7.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rq9s+JNhf0IChjtDXxllJ7g41oZk5SlXtp0LHwyA5cejwn7vKmKp4pPri6YEePv2PU65sAsegbXtIinmDFDXgQ==",
        "name": "acorn-jsx",
        "url": "https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz",
    },
    "acorn-walk@7.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OPdCF6GsMIP+Az+aWfAAOEt2/+iVDKE7oy6lJ098aoe59oAmK76qV6Gw60SbZ8jHuG2wH058GF4pLFbYamYrVA==",
        "name": "acorn-walk",
        "url": "https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.2.0.tgz",
    },
    "acorn@7.4.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-nQyp0o1/mNdbTO1PO6kHkwSrmgZ0MT/jCCpNiwbUjGoRN4dlBhqJtoQuCnEOKzgTVwg0ZWiCoQy6SxMebQVh8A==",
        "name": "acorn",
        "url": "https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz",
    },
    "acorn@8.7.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-V/LGr1APy+PXIwKebEWrkZPwoeoF+w1jiOBUmuxuiUIaOHtob8Qc9BTrYo7VuI5fR8tqsy+buA2WFooR5olqvQ==",
        "name": "acorn",
        "url": "https://registry.npmjs.org/acorn/-/acorn-8.7.0.tgz",
    },
    "agent-base@6.0.2": {
        "deps": [
            {
                "id": "debug@4.3.3-66eebb2b",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RZNwNclF7+MS/8bDg70amg32dyeZGZxiDuQmZxKLAlQjr3jGyLx+4Kkk58UO7D2QdgFIQCovuSuZESne6RG6XQ==",
        "name": "agent-base",
        "url": "https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz",
    },
    "agentkeepalive@4.2.0": {
        "deps": [
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "depd@1.1.2",
            },
            {
                "id": "humanize-ms@1.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0PhAp58jZNw13UJv7NVdTGb0ZcghHUb3DrZ046JiiJY/BOaTTpbwdHq2VObPCBV8M2GPh7sgrJ3AQ8Ey468LJw==",
        "name": "agentkeepalive",
        "url": "https://registry.npmjs.org/agentkeepalive/-/agentkeepalive-4.2.0.tgz",
    },
    "aggregate-error@3.1.0": {
        "deps": [
            {
                "id": "clean-stack@2.2.0",
            },
            {
                "id": "indent-string@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4I7Td01quW/RpocfNayFdFVk1qSuoh0E7JrbRJ16nH01HhKFQ88INq9Sd+nd72zqRySlr9BmDA8xlEJ6vJMrYA==",
        "name": "aggregate-error",
        "url": "https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz",
    },
    "ajv-keywords@3.5.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5p6WTN0DdTGVQk6VjcEju19IgaHudalcfabD7yhDGeA6bcQnmL+CpveLJq/3hvfwd1aof6L386Ougkx6RfyMIQ==",
        "name": "ajv-keywords",
        "url": "https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz",
    },
    "ajv-keywords@3.5.2-87046475": {
        "deps": [
            {
                "id": "ajv@6.12.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5p6WTN0DdTGVQk6VjcEju19IgaHudalcfabD7yhDGeA6bcQnmL+CpveLJq/3hvfwd1aof6L386Ougkx6RfyMIQ==",
        "name": "ajv-keywords",
        "url": "https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz",
    },
    "ajv@6.12.6": {
        "deps": [
            {
                "id": "fast-deep-equal@3.1.3",
            },
            {
                "id": "fast-json-stable-stringify@2.1.0",
            },
            {
                "id": "json-schema-traverse@0.4.1",
            },
            {
                "id": "uri-js@4.4.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-j3fVLgvTo527anyYyJOGTYJbG+vnnQYvE0m5mmkc1TK+nxAppkCLMIL0aZ4dblVCNoGShhm+kzE4ZUykBoMg4g==",
        "name": "ajv",
        "url": "https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz",
    },
    "ansi-colors@4.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JoX0apGbHaUJBNl6yF+p6JAFYZ666/hhCGKN5t9QFjbJQKUU/g8MNbFDbvfrgKXvI1QpZplPOnwIo99lX/AAmA==",
        "name": "ansi-colors",
        "url": "https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.1.tgz",
    },
    "ansi-escapes@4.3.2": {
        "deps": [
            {
                "id": "type-fest@0.21.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-gKXj5ALrKWQLsYG9jlTRmR/xKluxHV+Z9QEwNIgCfM1/uwPMCuzVVnh5mwTd+OuBZcwSIMbqssNWRm1lE51QaQ==",
        "name": "ansi-escapes",
        "url": "https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz",
    },
    "ansi-regex@5.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
        "name": "ansi-regex",
        "url": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
    },
    "ansi-styles@3.2.1": {
        "deps": [
            {
                "id": "color-convert@1.9.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VT0ZI6kZRdTh8YyJw3SMbYm/u+NqfsAxEpWO0Pf9sq8/e94WxxOpPKx9FR1FlyCtOVDNOQ+8ntlqFxiRc+r5qA==",
        "name": "ansi-styles",
        "url": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz",
    },
    "ansi-styles@4.3.0": {
        "deps": [
            {
                "id": "color-convert@2.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==",
        "name": "ansi-styles",
        "url": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz",
    },
    "ansi-styles@5.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Cxwpt2SfTzTtXcfOlzGEee8O+c+MmUgGrNiBcXnuWxuFJHe6a5Hz7qwhwe5OgaSYI0IJvkLqWX1ASG+cJOkEiA==",
        "name": "ansi-styles",
        "url": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz",
    },
    "anymatch@3.1.2": {
        "deps": [
            {
                "id": "normalize-path@3.0.0",
            },
            {
                "id": "picomatch@2.3.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-P43ePfOAIupkguHUycrc4qJ9kz8ZiuOUijaETwX7THt0Y/GNK7v0aa8rY816xWjZ7rJdA5XdMcpVFTKMq+RvWg==",
        "name": "anymatch",
        "url": "https://registry.npmjs.org/anymatch/-/anymatch-3.1.2.tgz",
    },
    "aproba@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lYe4Gx7QT+MKGbDsA+Z+he/Wtef0BiwDOlK/XkBrdfsh9J/jPPXbX0tE9x9cl27Tmu5gg3QUbUrQYa/y+KOHPQ==",
        "name": "aproba",
        "url": "https://registry.npmjs.org/aproba/-/aproba-2.0.0.tgz",
    },
    "are-we-there-yet@3.0.0": {
        "deps": [
            {
                "id": "delegates@1.0.0",
            },
            {
                "id": "readable-stream@3.6.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0GWpv50YSOcLXaN6/FAKY3vfRbllXWV2xvfA/oKJF8pzFhWXPV+yjhJXDBbjscDYowv7Yw1A3uigpzn5iEGTyw==",
        "name": "are-we-there-yet",
        "url": "https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-3.0.0.tgz",
    },
    "argparse@1.0.10": {
        "deps": [
            {
                "id": "sprintf-js@1.0.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-o5Roy6tNG4SL/FOkCAN6RzjiakZS25RLYFrcMttJqbdd8BWrnA+fGz57iN5Pb06pvBGvl5gQ0B48dJlslXvoTg==",
        "name": "argparse",
        "url": "https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz",
    },
    "argparse@2.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==",
        "name": "argparse",
        "url": "https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz",
    },
    "asynckit@0.4.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-jCVPMPcHkmRQQuTXH1kOxJ+OOGpHV3L3QwxzuWS1fc8=",
        "name": "asynckit",
        "url": "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz",
    },
    "babel-jest@27.5.1": {
        "deps": [
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
            {
                "id": "babel-plugin-istanbul@6.1.1",
            },
            {
                "id": "babel-preset-jest@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "slash@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cdQ5dXjGRd0IBRATiQ4mZGlGlRE8kJpjPOixdNRdT+m3UcNqmYWN6rK6nvtXYfY3D76cb8s/O1Ss8ea24PIwcg==",
        "name": "babel-jest",
        "url": "https://registry.npmjs.org/babel-jest/-/babel-jest-27.5.1.tgz",
    },
    "babel-jest@27.5.1-30a721e8": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
            {
                "id": "babel-plugin-istanbul@6.1.1",
            },
            {
                "id": "babel-preset-jest@27.5.1-19e4256f",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "slash@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cdQ5dXjGRd0IBRATiQ4mZGlGlRE8kJpjPOixdNRdT+m3UcNqmYWN6rK6nvtXYfY3D76cb8s/O1Ss8ea24PIwcg==",
        "name": "babel-jest",
        "url": "https://registry.npmjs.org/babel-jest/-/babel-jest-27.5.1.tgz",
    },
    "babel-plugin-istanbul@6.1.1": {
        "deps": [
            {
                "id": "@babel/helper-plugin-utils@7.16.7",
            },
            {
                "id": "@istanbuljs/load-nyc-config@1.1.0",
            },
            {
                "id": "@istanbuljs/schema@0.1.3",
            },
            {
                "id": "istanbul-lib-instrument@5.1.0",
            },
            {
                "id": "test-exclude@6.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Y1IQok9821cC9onCx5otgFfRm7Lm+I+wwxOx738M/WLPZ9Q42m4IG5W0FNX8WLL2gYMZo3JkuXIH2DOpWM+qwA==",
        "name": "babel-plugin-istanbul",
        "url": "https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz",
    },
    "babel-plugin-jest-hoist@27.5.1": {
        "deps": [
            {
                "id": "@babel/template@7.16.7",
            },
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
            {
                "id": "@types/babel__traverse@7.14.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-50wCwD5EMNW4aRpOwtqzyZHIewTYNxLA4nhB+09d8BIssfNfzBRhkBIHiaPv1Si226TQSvp8gxAJm2iY2qs2hQ==",
        "name": "babel-plugin-jest-hoist",
        "url": "https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-27.5.1.tgz",
    },
    "babel-preset-current-node-syntax@1.0.1": {
        "deps": [
            {
                "id": "@babel/plugin-syntax-async-generators@7.8.4",
            },
            {
                "id": "@babel/plugin-syntax-bigint@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-class-properties@7.12.13",
            },
            {
                "id": "@babel/plugin-syntax-import-meta@7.10.4",
            },
            {
                "id": "@babel/plugin-syntax-json-strings@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-logical-assignment-operators@7.10.4",
            },
            {
                "id": "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-numeric-separator@7.10.4",
            },
            {
                "id": "@babel/plugin-syntax-object-rest-spread@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-optional-catch-binding@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-optional-chaining@7.8.3",
            },
            {
                "id": "@babel/plugin-syntax-top-level-await@7.14.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-M7LQ0bxarkxQoN+vz5aJPsLBn77n8QgTFmo8WK0/44auK2xlCXrYcUxHFxgU7qW5Yzw/CjmLRK2uJzaCd7LvqQ==",
        "name": "babel-preset-current-node-syntax",
        "url": "https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz",
    },
    "babel-preset-current-node-syntax@1.0.1-227eba3d": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/plugin-syntax-async-generators@7.8.4-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-bigint@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-class-properties@7.12.13-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-import-meta@7.10.4-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-json-strings@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-logical-assignment-operators@7.10.4-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-numeric-separator@7.10.4-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-object-rest-spread@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-optional-catch-binding@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-optional-chaining@7.8.3-960d8897",
            },
            {
                "id": "@babel/plugin-syntax-top-level-await@7.14.5-960d8897",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-M7LQ0bxarkxQoN+vz5aJPsLBn77n8QgTFmo8WK0/44auK2xlCXrYcUxHFxgU7qW5Yzw/CjmLRK2uJzaCd7LvqQ==",
        "name": "babel-preset-current-node-syntax",
        "url": "https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz",
    },
    "babel-preset-current-node-syntax@1.0.1-b26687be": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/plugin-syntax-async-generators@7.8.4-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-bigint@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-class-properties@7.12.13-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-import-meta@7.10.4-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-json-strings@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-logical-assignment-operators@7.10.4-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-nullish-coalescing-operator@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-numeric-separator@7.10.4-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-object-rest-spread@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-optional-catch-binding@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-optional-chaining@7.8.3-f9e5bbd4",
            },
            {
                "id": "@babel/plugin-syntax-top-level-await@7.14.5-f9e5bbd4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-M7LQ0bxarkxQoN+vz5aJPsLBn77n8QgTFmo8WK0/44auK2xlCXrYcUxHFxgU7qW5Yzw/CjmLRK2uJzaCd7LvqQ==",
        "name": "babel-preset-current-node-syntax",
        "url": "https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz",
    },
    "babel-preset-jest@27.5.1": {
        "deps": [
            {
                "id": "babel-plugin-jest-hoist@27.5.1",
            },
            {
                "id": "babel-preset-current-node-syntax@1.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Nptf2FzlPCWYuJg41HBqXVT8ym6bXOevuCTbhxlUpjwtysGaIWFvDEjp4y+G7fl13FgOdjs7P/DmErqH7da0Ag==",
        "name": "babel-preset-jest",
        "url": "https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-27.5.1.tgz",
    },
    "babel-preset-jest@27.5.1-19e4256f": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@types/babel__core@7.1.18",
            },
            {
                "id": "babel-plugin-jest-hoist@27.5.1",
            },
            {
                "id": "babel-preset-current-node-syntax@1.0.1-227eba3d",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Nptf2FzlPCWYuJg41HBqXVT8ym6bXOevuCTbhxlUpjwtysGaIWFvDEjp4y+G7fl13FgOdjs7P/DmErqH7da0Ag==",
        "name": "babel-preset-jest",
        "url": "https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-27.5.1.tgz",
    },
    "balanced-match@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==",
        "name": "balanced-match",
        "url": "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz",
    },
    "base64-js@1.5.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AKpaYlHn8t4SVbOHCy+b5+KKgvR4vrsD8vbvrbiQJps7fKDTkjkDry6ji0rUJjC0kzbNePLwzxq8iypo41qeWA==",
        "name": "base64-js",
        "url": "https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz",
    },
    "bl@4.1.0": {
        "deps": [
            {
                "id": "buffer@5.7.1",
            },
            {
                "id": "inherits@2.0.4",
            },
            {
                "id": "readable-stream@3.6.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1W07cM9gS6DcLperZfFSj+bWLtaPGSOHWhPiGzXmvVJbRLdG82sH/Kn8EtW1VqWVA54AKf2h5k5BbnIbwF3h6w==",
        "name": "bl",
        "url": "https://registry.npmjs.org/bl/-/bl-4.1.0.tgz",
    },
    "brace-expansion@1.1.11": {
        "deps": [
            {
                "id": "balanced-match@1.0.2",
            },
            {
                "id": "concat-map@0.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==",
        "name": "brace-expansion",
        "url": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz",
    },
    "braces@3.0.2": {
        "deps": [
            {
                "id": "fill-range@7.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-b8um+L1RzM3WDSzvhm6gIz1yfTbBt6YTlcEKAvsmqCZZFw46z626lVj9j1yEPW33H5H+lBQpZMP1k8l+78Ha0A==",
        "name": "braces",
        "url": "https://registry.npmjs.org/braces/-/braces-3.0.2.tgz",
    },
    "browser-process-hrtime@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9o5UecI3GhkpM6DrXr69PblIuWxPKk9Y0jHBRhdocZ2y7YECBFCsHm79Pr3OyR2AvjhDkabFJaDJMYRazHgsow==",
        "name": "browser-process-hrtime",
        "url": "https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz",
    },
    "browserslist@4.19.1": {
        "deps": [
            {
                "id": "caniuse-lite@1.0.30001311",
            },
            {
                "id": "electron-to-chromium@1.4.68",
            },
            {
                "id": "escalade@3.1.1",
            },
            {
                "id": "node-releases@2.0.2",
            },
            {
                "id": "picocolors@1.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-u2tbbG5PdKRTUoctO3NBD8FQ5HdPh1ZXPHzp1rwaa5jTc+RV9/+RlWiAIKmjRPQF+xbGM9Kklj5bZQFa2s/38A==",
        "name": "browserslist",
        "url": "https://registry.npmjs.org/browserslist/-/browserslist-4.19.1.tgz",
    },
    "bser@2.1.1": {
        "deps": [
            {
                "id": "node-int64@0.4.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-gQxTNE/GAfIIrmHLUE3oJyp5FO6HRBfhjnw4/wMmA63ZGDJnWBmgY/lyQBpnDUkGmAhbSe39tx2d/iTOAfglwQ==",
        "name": "bser",
        "url": "https://registry.npmjs.org/bser/-/bser-2.1.1.tgz",
    },
    "buffer-from@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-E+XQCRwSbaaiChtv6k6Dwgc+bx+Bs6vuKJHHl5kox/BaKbhiXzqQOwK4cO22yElGp2OCmjwVhT3HmxgyPGnJfQ==",
        "name": "buffer-from",
        "url": "https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz",
    },
    "buffer@5.7.1": {
        "deps": [
            {
                "id": "base64-js@1.5.1",
            },
            {
                "id": "ieee754@1.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EHcyIPBQ4BSGlvjB16k5KgAJ27CIsHY/2JBmCRReo48y9rQ3MaUzWX3KVlBa4U7MyX02HdVj0K7C3WaB3ju7FQ==",
        "name": "buffer",
        "url": "https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz",
    },
    "builtin-modules@3.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lGzLKcioL90C7wMczpkY0n/oART3MbBa8R9OFGE1rJxoVI86u4WAGfEk8Wjv10eKSyTHVGkSo3bvBylCEtk7LA==",
        "name": "builtin-modules",
        "url": "https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.2.0.tgz",
    },
    "cacache@15.3.0": {
        "deps": [
            {
                "id": "@npmcli/fs@1.1.1",
            },
            {
                "id": "@npmcli/move-file@1.1.2",
            },
            {
                "id": "chownr@2.0.0",
            },
            {
                "id": "fs-minipass@2.1.0",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "infer-owner@1.0.4",
            },
            {
                "id": "lru-cache@6.0.0",
            },
            {
                "id": "minipass-collect@1.0.2",
            },
            {
                "id": "minipass-flush@1.0.5",
            },
            {
                "id": "minipass-pipeline@1.2.4",
            },
            {
                "id": "minipass@3.1.6",
            },
            {
                "id": "mkdirp@1.0.4",
            },
            {
                "id": "p-map@4.0.0",
            },
            {
                "id": "promise-inflight@1.0.1-a7e5239c",
            },
            {
                "id": "rimraf@3.0.2",
            },
            {
                "id": "ssri@8.0.1",
            },
            {
                "id": "tar@6.1.11",
            },
            {
                "id": "unique-filename@1.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VVdYzXEn+cnbXpFgWs5hTT7OScegHVmLhJIR8Ufqk3iFD6A6j5iSX1KuBTfNEv4tdJWE2PzA6IVFtcLC7fN9wQ==",
        "name": "cacache",
        "url": "https://registry.npmjs.org/cacache/-/cacache-15.3.0.tgz",
    },
    "callsites@3.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-P8BjAsXvZS+VIDUI11hHCQEv74YT67YUi5JJFNWIqL235sBmjX4+qx9Muvls5ivyNENctx46xQLQ3aTuE7ssaQ==",
        "name": "callsites",
        "url": "https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz",
    },
    "camelcase@5.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-L28STB170nwWS63UjtlEOE3dldQApaJXZkOI1uMFfzf3rRuPegHaHesyee+YxQ+W6SvRDQV6UrdOdRiR153wJg==",
        "name": "camelcase",
        "url": "https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz",
    },
    "camelcase@6.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Gmy6FhYlCY7uOElZUSbxo2UCDH8owEk996gkbrpsgGtrJLM3J7jGxl9Ic7Qwwj4ivOE5AWZWRMecDdF7hqGjFA==",
        "name": "camelcase",
        "url": "https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz",
    },
    "caniuse-lite@1.0.30001311": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mleTFtFKfykEeW34EyfhGIFjGCqzhh38Y0LhdQ9aWF+HorZTtdgKV/1hEE0NlFkG2ubvisPV6l400tlbPys98A==",
        "name": "caniuse-lite",
        "url": "https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001311.tgz",
    },
    "chalk@2.4.2": {
        "deps": [
            {
                "id": "ansi-styles@3.2.1",
            },
            {
                "id": "escape-string-regexp@1.0.5",
            },
            {
                "id": "supports-color@5.5.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Mti+f9lpJNcwF4tWV8/OrTTtF1gZi+f8FqlyAdouralcFWFQWF2+NgCHShjkCb+IFBLq9buZwE1xckQU4peSuQ==",
        "name": "chalk",
        "url": "https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz",
    },
    "chalk@4.1.2": {
        "deps": [
            {
                "id": "ansi-styles@4.3.0",
            },
            {
                "id": "supports-color@7.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==",
        "name": "chalk",
        "url": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
    },
    "char-regex@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-kWWXztvZ5SBQV+eRgKFeh8q5sLuZY2+8WUIzlxWVTg+oGwY14qylx1KbKzHd8P6ZYkAg0xyIDU9JMHhyJMZ1jw==",
        "name": "char-regex",
        "url": "https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz",
    },
    "chownr@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-bIomtDF5KGpdogkLd9VspvFzk9KfpyyGlS8YFVZl7TGPBHL5snIOnxeshwVgPteQ9b4Eydl+pVbIyE1DcvCWgQ==",
        "name": "chownr",
        "url": "https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz",
    },
    "chrome-trace-event@1.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-p3KULyQg4S7NIHixdwbGX+nFHkoBiA4YQmyWtjb8XngSKV124nJmRysgAeujbUVb15vh+RvFUfCPqU7rXk+hZg==",
        "name": "chrome-trace-event",
        "url": "https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz",
    },
    "ci-info@3.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-riT/3vI5YpVH6/qomlDnJow6TBee2PBKSEpx3O32EGPYbWGIRsIlGRms3Sm74wYE1JMo8RnO04Hb12+v1J5ICw==",
        "name": "ci-info",
        "url": "https://registry.npmjs.org/ci-info/-/ci-info-3.3.0.tgz",
    },
    "cjs-module-lexer@1.2.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cOU9usZw8/dXIXKtwa8pM0OTJQuJkxMN6w30csNRUerHfeQ5R6U3kkU/FtJeIf3M202OHfY2U8ccInBG7/xogA==",
        "name": "cjs-module-lexer",
        "url": "https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.2.tgz",
    },
    "clean-stack@2.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4diC9HaTE+KRAMWhDhrGOECgWZxoevMc5TlkObMqNSsVU62PYzXZ/SMTjzyGAFF1YusgxGcSWTEXBhp0CPwQ1A==",
        "name": "clean-stack",
        "url": "https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz",
    },
    "cliui@7.0.4": {
        "deps": [
            {
                "id": "string-width@4.2.3",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
            {
                "id": "wrap-ansi@7.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OcRE68cOsVMXp1Yvonl/fzkQOyjLSu/8bhPDfQt0e0/Eb283TKP20Fs2MqoPsr9SwA595rRCA+QMzYc9nBP+JQ==",
        "name": "cliui",
        "url": "https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz",
    },
    "co@4.6.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-IdQ2Kko4IuaP4YUkCTgd0L6YUXVuq/v20HI+9R45z5g=",
        "name": "co",
        "url": "https://registry.npmjs.org/co/-/co-4.6.0.tgz",
    },
    "collect-v8-coverage@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-iBPtljfCNcTKNAto0KEtDfZ3qzjJvqE3aTGZsbhjSBlorqpXJlaWWtPO35D+ZImoC3KWejX64o+yPGxhWSTzfg==",
        "name": "collect-v8-coverage",
        "url": "https://registry.npmjs.org/collect-v8-coverage/-/collect-v8-coverage-1.0.1.tgz",
    },
    "color-convert@1.9.3": {
        "deps": [
            {
                "id": "color-name@1.1.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==",
        "name": "color-convert",
        "url": "https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz",
    },
    "color-convert@2.0.1": {
        "deps": [
            {
                "id": "color-name@1.1.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
        "name": "color-convert",
        "url": "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz",
    },
    "color-name@1.1.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-sO8zcfslY8vrY3nxY53CqMColdHUiscsetQ8X/QJeE4=",
        "name": "color-name",
        "url": "https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz",
    },
    "color-name@1.1.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==",
        "name": "color-name",
        "url": "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz",
    },
    "color-support@1.1.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qiBjkpbMLO/HL68y+lh4q0/O1MZFj2RX6X/KmMa3+gJD3z+WwI1ZzDHysvqHGS3mP6mznPckpXmw1nI9cJjyRg==",
        "name": "color-support",
        "url": "https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz",
    },
    "combined-stream@1.0.8": {
        "deps": [
            {
                "id": "delayed-stream@1.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-FQN4MRfuJeHf7cBbBMJFXhKSDq+2kAArBlmRBvcvFE5BB1HZKXtSFASDhdlz9zOYwxh8lDdnvmMOe/+5cdoEdg==",
        "name": "combined-stream",
        "url": "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz",
    },
    "commander@2.20.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GpVkmM8vF2vQUkj2LvZmD35JxeJOLCwJ9cUkugyk2nuhbv3+mJvpLYYt+0+USMxE+oj+ey/lJEnhZw75x/OMcQ==",
        "name": "commander",
        "url": "https://registry.npmjs.org/commander/-/commander-2.20.3.tgz",
    },
    "commondir@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-W4mFG+T3mZI+SDIKExZYg9L/y4zU7HECMmMlVJfCUbA=",
        "name": "commondir",
        "url": "https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz",
    },
    "concat-map@0.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-NZAt1iDPAFjEnqYUEg8YqInZhCaakDgbdiLnnCz+QmE=",
        "name": "concat-map",
        "url": "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz",
    },
    "console-control-strings@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-8NSbSAz6vPhsmLcp5NypZtF9GHFSuUWJg7iJRzoSgzY=",
        "name": "console-control-strings",
        "url": "https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz",
    },
    "convert-source-map@1.8.0": {
        "deps": [
            {
                "id": "safe-buffer@5.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+OQdjP49zViI/6i7nIJpA8rAl4sV/JdPfU9nZs3VqOwGIgizICvuN2ru6fMd+4llL0tar18UYJXfZ/TWtmhUjA==",
        "name": "convert-source-map",
        "url": "https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.8.0.tgz",
    },
    "cross-spawn@7.0.3": {
        "deps": [
            {
                "id": "path-key@3.1.1",
            },
            {
                "id": "shebang-command@2.0.0",
            },
            {
                "id": "which@2.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==",
        "name": "cross-spawn",
        "url": "https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz",
    },
    "cssom@0.3.8": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-b0tGHbfegbhPJpxpiBPU2sCkigAqtM9O121le6bbOlgyV+NyGyCmVfJ6QW9eRjz8CpNfWEOYBIMIGRYkLwsIYg==",
        "name": "cssom",
        "url": "https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz",
    },
    "cssom@0.4.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-p3pvU7r1MyyqbTk+WbNJIgJjG2VmTIaB10rI93LzVPrmDJKkzKYMtxxyAvQXR/NS6otuzveI7+7BBq3SjBS2mw==",
        "name": "cssom",
        "url": "https://registry.npmjs.org/cssom/-/cssom-0.4.4.tgz",
    },
    "cssstyle@2.3.0": {
        "deps": [
            {
                "id": "cssom@0.3.8",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AZL67abkUzIuvcHqk7c09cezpGNcxUxU4Ioi/05xHk4DQeTkWmGYftIE6ctU6AEt+Gn4n1lDStOtj7FKycP71A==",
        "name": "cssstyle",
        "url": "https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz",
    },
    "data-urls@2.0.0": {
        "deps": [
            {
                "id": "abab@2.0.5",
            },
            {
                "id": "whatwg-mimetype@2.3.0",
            },
            {
                "id": "whatwg-url@8.7.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-X5eWTSXO/BJmpdIKCRuKUgSCgAN0OwliVK3yPKbwIWU1Tdw5BRajxlzMidvh+gwko9AfQ9zIj52pzF91Q3YAvQ==",
        "name": "data-urls",
        "url": "https://registry.npmjs.org/data-urls/-/data-urls-2.0.0.tgz",
    },
    "dataloader@1.4.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-68s5jYdlvasItOJnCuI2Q9s4q98g0pCyL3HrcKJu8KNugUl8ahgmZYg38ysLTgQjjXX3H8CJLkAvWrclWfcalw==",
        "name": "dataloader",
        "url": "https://registry.npmjs.org/dataloader/-/dataloader-1.4.0.tgz",
    },
    "debug@4.3.3": {
        "deps": [
            {
                "id": "ms@2.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/zxw5+vh1Tfv+4Qn7a5nsbcJKPaSvCDhojn6FEl9vupwK2VCSDtEiEtqr8DFtzYFOdz63LBkxec7DYuc2jon6Q==",
        "name": "debug",
        "url": "https://registry.npmjs.org/debug/-/debug-4.3.3.tgz",
    },
    "debug@4.3.3-66eebb2b": {
        "deps": [
            {
                "id": "ms@2.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/zxw5+vh1Tfv+4Qn7a5nsbcJKPaSvCDhojn6FEl9vupwK2VCSDtEiEtqr8DFtzYFOdz63LBkxec7DYuc2jon6Q==",
        "name": "debug",
        "url": "https://registry.npmjs.org/debug/-/debug-4.3.3.tgz",
    },
    "decimal.js@10.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-V0pfhfr8suzyPGOx3nmq4aHqabehUZn6Ch9kyFpV79TGDTWFmHqUqXdabR7QHqxzrYolF4+tVmJhUG4OURg5dQ==",
        "name": "decimal.js",
        "url": "https://registry.npmjs.org/decimal.js/-/decimal.js-10.3.1.tgz",
    },
    "dedent@0.7.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-vbJrm5xjzCYgxMMJk8wRhw/QbwX1gmnAXqGadY+g7Cs=",
        "name": "dedent",
        "url": "https://registry.npmjs.org/dedent/-/dedent-0.7.0.tgz",
    },
    "deep-is@0.1.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==",
        "name": "deep-is",
        "url": "https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz",
    },
    "deepmerge@4.2.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-FJ3UgI4gIl+PHZm53knsuSFpE+nESMr7M4v9QcgB7S63Kj/6WqMiFQJpBBYz1Pt+66bZpP3Q7Lye0Oo9MPKEdg==",
        "name": "deepmerge",
        "url": "https://registry.npmjs.org/deepmerge/-/deepmerge-4.2.2.tgz",
    },
    "delayed-stream@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-rDj85CF9+x13JCfH2NDQc+NezYMpFel6YdmrXFBBKdM=",
        "name": "delayed-stream",
        "url": "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz",
    },
    "delegates@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-v+/b9BHtUKlMe++911/EnE/1OwY9SB4Fu6wvZwrPZGE=",
        "name": "delegates",
        "url": "https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz",
    },
    "depd@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-g+Jr5rWCEVLHigskfIKQwsteCgp/j2c+8jhIeuErxBw=",
        "name": "depd",
        "url": "https://registry.npmjs.org/depd/-/depd-1.1.2.tgz",
    },
    "detect-newline@3.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TLz+x/vEXm/Y7P7wn1EJFNLxYpUD4TgMosxY6fAVJUnJMbupHBOncxyWUG9OpTaH9EBD7uFI5LfEgmMOc54DsA==",
        "name": "detect-newline",
        "url": "https://registry.npmjs.org/detect-newline/-/detect-newline-3.1.0.tgz",
    },
    "diff-sequences@27.5.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-k1gCAXAsNgLwEL+Y8Wvl+M6oEFj5bgazfZULpS5CneoPPXRaCCW7dm+q21Ky2VEE5X+VeRDBVg1Pcvvsr4TtNQ==",
        "name": "diff-sequences",
        "url": "https://registry.npmjs.org/diff-sequences/-/diff-sequences-27.5.1.tgz",
    },
    "doctrine@3.0.0": {
        "deps": [
            {
                "id": "esutils@2.0.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yS+Q5i3hBf7GBkd4KG8a7eBNNWNGLTaEwwYWUijIYM7zrlYDM0BFXHjjPWlWZ1Rg7UaddZeIDmi9jF3HmqiQ2w==",
        "name": "doctrine",
        "url": "https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz",
    },
    "domexception@2.0.1": {
        "deps": [
            {
                "id": "webidl-conversions@5.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yxJ2mFy/sibVQlu5qHjOkf9J3K6zgmCxgJ94u2EdvDOV09H+32LtRswEcUsmUWN72pVLOEnTSRaIVVzVQgS0dg==",
        "name": "domexception",
        "url": "https://registry.npmjs.org/domexception/-/domexception-2.0.1.tgz",
    },
    "electron-to-chromium@1.4.68": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cId+QwWrV8R1UawO6b9BR1hnkJ4EJPCPAr4h315vliHUtVUJDk39Sg1PMNnaWKfj5x+93ssjeJ9LKL6r8LaMiA==",
        "name": "electron-to-chromium",
        "url": "https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.68.tgz",
    },
    "emittery@0.8.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-uDfvUjVrfGJJhymx/kz6prltenw1u7WrCg1oa94zYY8xxVpLLUu045LAT0dhDZdXG58/EpPL/5kA180fQ/qudg==",
        "name": "emittery",
        "url": "https://registry.npmjs.org/emittery/-/emittery-0.8.1.tgz",
    },
    "emoji-regex@8.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==",
        "name": "emoji-regex",
        "url": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz",
    },
    "encoding@0.1.13": {
        "deps": [
            {
                "id": "iconv-lite@0.6.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ETBauow1T35Y/WZMkio9jiM0Z5xjHHmJ4XmjZOq1l/dXz3lr2sRn87nJy20RupqSh1F2m3HHPSp8ShIPQJrJ3A==",
        "name": "encoding",
        "url": "https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz",
    },
    "end-of-stream@1.4.4": {
        "deps": [
            {
                "id": "once@1.4.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+uw1inIHVPQoaVuHzRyXd21icM+cnt4CzD5rW+NC1wjOUSTOs+Te7FOv7AhN7vS9x/oIyhLP5PR1H+phQAHu5Q==",
        "name": "end-of-stream",
        "url": "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz",
    },
    "enhanced-resolve@5.8.3": {
        "deps": [
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "tapable@2.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EGAbGvH7j7Xt2nc0E7D99La1OiEs8LnyimkRgwExpUMScN6O+3x9tIWs7PLQZVNx4YD+00skHXPXi1yQHpAmZA==",
        "name": "enhanced-resolve",
        "url": "https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.8.3.tgz",
    },
    "enhanced-resolve@5.9.0": {
        "deps": [
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "tapable@2.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-weDYmzbBygL7HzGGS26M3hGQx68vehdEg6VUmqSOaFzXExFqlnKuSvsEJCVGQHScS8CQMbrAqftT+AzzHNt/YA==",
        "name": "enhanced-resolve",
        "url": "https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.9.0.tgz",
    },
    "enquirer@2.3.6": {
        "deps": [
            {
                "id": "ansi-colors@4.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yjNnPr315/FjS4zIsUxYguYUPP2e1NK4d7E7ZOLiyYCcbFBiTMyID+2wvm2w6+pZ/odMA7cRkjhsPbltwBOrLg==",
        "name": "enquirer",
        "url": "https://registry.npmjs.org/enquirer/-/enquirer-2.3.6.tgz",
    },
    "env-paths@2.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+h1lkLKhZMTYjog1VEpJNG7NZJWcuc2DDk/qsqSTRRCOXiLjeQ1d1/udrUGhqMxUgAlwKNZ0cf2uqan5GLuS2A==",
        "name": "env-paths",
        "url": "https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz",
    },
    "err-code@2.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-2bmlRpNKBxT/CRmPOlyISQpNj+qSeYvcym/uT0Jx2bMOlKLtSy1ZmLuVxSEKKyor/N5yhvp/ZiG1oE3DEYMSFA==",
        "name": "err-code",
        "url": "https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz",
    },
    "error-ex@1.3.2": {
        "deps": [
            {
                "id": "is-arrayish@0.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7dFHNmqeFSEt2ZBsCriorKnn3Z2pj+fd9kmI6QoWw4//DL+icEBfc0U7qJCisqrTsKTjw4fNFy2pW9OqStD84g==",
        "name": "error-ex",
        "url": "https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz",
    },
    "es-module-lexer@0.9.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1HQ2M2sPtxwnvOvT1ZClHyQDiggdNjURWpY2we6aMKCQiUVxTmVs2UYPLIrD84sS+kMdUwfBSylbJPwNnBrnHQ==",
        "name": "es-module-lexer",
        "url": "https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-0.9.3.tgz",
    },
    "escalade@3.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-k0er2gUkLf8O0zKJiAhmkTnJlTvINGv7ygDNPbeIsX/TJjGJZHuh9B2UxbsaEkmlEo9MfhrSzmhIlhRlI2GXnw==",
        "name": "escalade",
        "url": "https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz",
    },
    "escape-string-regexp@1.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-5Qx5LnZ2PQx0UGKXrdd5dVlnypu9KI4md5Zqa3OUw0c=",
        "name": "escape-string-regexp",
        "url": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz",
    },
    "escape-string-regexp@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-UpzcLCXolUWcNu5HtVMHYdXJjArjsF9C0aNnquZYY4uW/Vu0miy5YoWvbV345HauVvcAUnpRuhMMcqTcGOY2+w==",
        "name": "escape-string-regexp",
        "url": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz",
    },
    "escape-string-regexp@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==",
        "name": "escape-string-regexp",
        "url": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz",
    },
    "escodegen@2.0.0": {
        "deps": [
            {
                "id": "esprima@4.0.1",
            },
            {
                "id": "estraverse@5.3.0",
            },
            {
                "id": "esutils@2.0.3",
            },
            {
                "id": "optionator@0.8.3",
            },
            {
                "id": "source-map@0.6.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mmHKys/C8BFUGI+MAWNcSYoORYLMdPzjrknd2Vc+bUsjN5bXcr8EhrNB+UTqfL1y3I9c4fw2ihgtMPQLBRiQxw==",
        "name": "escodegen",
        "url": "https://registry.npmjs.org/escodegen/-/escodegen-2.0.0.tgz",
    },
    "eslint-scope@5.1.1": {
        "deps": [
            {
                "id": "esrecurse@4.3.0",
            },
            {
                "id": "estraverse@4.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-2NxwbF/hZ0KpepYN0cNbo+FN6XoK7GaHlQhgx/hIZl6Va0bF45RQOOwhLIy8lQDbuCiadSLCBnH2CFYquit5bw==",
        "name": "eslint-scope",
        "url": "https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz",
    },
    "eslint-scope@7.1.1": {
        "deps": [
            {
                "id": "esrecurse@4.3.0",
            },
            {
                "id": "estraverse@5.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-QKQM/UXpIiHcLqJ5AOyIW7XZmzjkzQXYE54n1++wb0u9V/abW3l9uQnxX8Z5Xd18xyKIMTUAyQ0k1e8pz6LUrw==",
        "name": "eslint-scope",
        "url": "https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.1.1.tgz",
    },
    "eslint-utils@3.0.0": {
        "deps": [
            {
                "id": "eslint-visitor-keys@2.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-uuQC43IGctw68pJA1RgbQS8/NP7rch6Cwd4j3ZBtgo4/8Flj4eGE7ZYSZRN3iq5pVUv6GPdW5Z1RFleo84uLDA==",
        "name": "eslint-utils",
        "url": "https://registry.npmjs.org/eslint-utils/-/eslint-utils-3.0.0.tgz",
    },
    "eslint-utils@3.0.0-19231e7a": {
        "deps": [
            {
                "id": "eslint-visitor-keys@2.1.0",
            },
        ],
        "extra_deps": {
            "eslint-utils@3.0.0-19231e7a": [
                {
                    "id": "eslint@8.3.0",
                },
            ],
            "eslint@8.3.0": [
                {
                    "id": "eslint-utils@3.0.0-19231e7a",
                },
            ],
        },
        "integrity": "sha512-uuQC43IGctw68pJA1RgbQS8/NP7rch6Cwd4j3ZBtgo4/8Flj4eGE7ZYSZRN3iq5pVUv6GPdW5Z1RFleo84uLDA==",
        "name": "eslint-utils",
        "url": "https://registry.npmjs.org/eslint-utils/-/eslint-utils-3.0.0.tgz",
    },
    "eslint-visitor-keys@2.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0rSmRBzXgDzIsD6mGdJgevzgezI534Cer5L/vyMX0kHzT/jiB43jRhd9YUlMGYLQy2zprNmoT8qasCGtY+QaKw==",
        "name": "eslint-visitor-keys",
        "url": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz",
    },
    "eslint-visitor-keys@3.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mQ+suqKJVyeuwGYHAdjMFqjCyfl8+Ldnxuyp3ldiMBFKkvytrXUZWaiPCEav8qDHKty44bD+qV1IP4T+w+xXRA==",
        "name": "eslint-visitor-keys",
        "url": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.3.0.tgz",
    },
    "eslint@8.3.0": {
        "deps": [
            {
                "id": "@eslint/eslintrc@1.1.0",
            },
            {
                "id": "@humanwhocodes/config-array@0.6.0",
            },
            {
                "id": "ajv@6.12.6",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "cross-spawn@7.0.3",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "doctrine@3.0.0",
            },
            {
                "id": "enquirer@2.3.6",
            },
            {
                "id": "escape-string-regexp@4.0.0",
            },
            {
                "id": "eslint-scope@7.1.1",
            },
            {
                "id": "eslint-visitor-keys@3.3.0",
            },
            {
                "id": "espree@9.3.1",
            },
            {
                "id": "esquery@1.4.0",
            },
            {
                "id": "esutils@2.0.3",
            },
            {
                "id": "fast-deep-equal@3.1.3",
            },
            {
                "id": "file-entry-cache@6.0.1",
            },
            {
                "id": "functional-red-black-tree@1.0.1",
            },
            {
                "id": "glob-parent@6.0.2",
            },
            {
                "id": "globals@13.12.1",
            },
            {
                "id": "ignore@4.0.6",
            },
            {
                "id": "import-fresh@3.3.0",
            },
            {
                "id": "imurmurhash@0.1.4",
            },
            {
                "id": "is-glob@4.0.3",
            },
            {
                "id": "js-yaml@4.1.0",
            },
            {
                "id": "json-stable-stringify-without-jsonify@1.0.1",
            },
            {
                "id": "levn@0.4.1",
            },
            {
                "id": "lodash.merge@4.6.2",
            },
            {
                "id": "minimatch@3.0.5",
            },
            {
                "id": "natural-compare@1.4.0",
            },
            {
                "id": "optionator@0.9.1",
            },
            {
                "id": "progress@2.0.3",
            },
            {
                "id": "regexpp@3.2.0",
            },
            {
                "id": "semver@7.3.5",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
            {
                "id": "strip-json-comments@3.1.1",
            },
            {
                "id": "text-table@0.2.0",
            },
            {
                "id": "v8-compile-cache@2.3.0",
            },
        ],
        "extra_deps": {
            "eslint-utils@3.0.0-19231e7a": [
                {
                    "id": "eslint@8.3.0",
                },
            ],
            "eslint@8.3.0": [
                {
                    "id": "eslint-utils@3.0.0-19231e7a",
                },
            ],
        },
        "integrity": "sha512-aIay56Ph6RxOTC7xyr59Kt3ewX185SaGnAr8eWukoPLeriCrvGjvAubxuvaXOfsxhtwV5g0uBOsyhAom4qJdww==",
        "name": "eslint",
        "url": "https://registry.npmjs.org/eslint/-/eslint-8.3.0.tgz",
    },
    "espree@9.3.1": {
        "deps": [
            {
                "id": "acorn-jsx@5.3.2-0c9e34c3",
            },
            {
                "id": "acorn@8.7.0",
            },
            {
                "id": "eslint-visitor-keys@3.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-bvdyLmJMfwkV3NCRl5ZhJf22zBFo1y8bYh3VYb+bfzqNB4Je68P2sSuXyuFquzWLebHpNd2/d5uv7yoP9ISnGQ==",
        "name": "espree",
        "url": "https://registry.npmjs.org/espree/-/espree-9.3.1.tgz",
    },
    "esprima@4.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==",
        "name": "esprima",
        "url": "https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz",
    },
    "esquery@1.4.0": {
        "deps": [
            {
                "id": "estraverse@5.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cCDispWt5vHHtwMY2YrAQ4ibFkAL8RbH5YGBnZBc90MolvvfkkQcJro/aZiAQUlQ3qgrYS6D6v8Gc5G5CQsc9w==",
        "name": "esquery",
        "url": "https://registry.npmjs.org/esquery/-/esquery-1.4.0.tgz",
    },
    "esrecurse@4.3.0": {
        "deps": [
            {
                "id": "estraverse@5.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KmfKL3b6G+RXvP8N1vr3Tq1kL/oCFgn2NYXEtqP8/L3pKapUA4G8cFVaoF3SU323CD4XypR/ffioHmkti6/Tag==",
        "name": "esrecurse",
        "url": "https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz",
    },
    "estraverse@4.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-39nnKffWz8xN1BU/2c79n9nB9HDzo0niYUqx6xyqUnyoAnQyyWpOTdZEeiCch8BBu515t4wp9ZmgVfVhn9EBpw==",
        "name": "estraverse",
        "url": "https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz",
    },
    "estraverse@5.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==",
        "name": "estraverse",
        "url": "https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz",
    },
    "estree-walker@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1fMXF3YP4pZZVozF8j/ZLfvnR8NSIljt56UhbZ5PeeDmmGHpgpdwQt7ITlGvYaQukCvuBRMLEiKiYC+oeIg4cg==",
        "name": "estree-walker",
        "url": "https://registry.npmjs.org/estree-walker/-/estree-walker-1.0.1.tgz",
    },
    "estree-walker@2.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Rfkk/Mp/DL7JVje3u18FxFujQlTNR2q6QfMSMB7AvCBx91NGj/ba3kCfza0f6dVDbw7YlRf/nDrn7pQrCCyQ/w==",
        "name": "estree-walker",
        "url": "https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz",
    },
    "esutils@2.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-kVscqXk4OCp68SZ0dkgEKVi6/8ij300KBWTJq32P/dYeWTSwK41WyTxalN1eRmA5Z9UU/LX9D7FWSmV9SAYx6g==",
        "name": "esutils",
        "url": "https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz",
    },
    "events@3.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mQw+2fkQbALzQ7V0MY0IqdnXNOeTtP4r0lN9z7AAawCXgqea7bDii20AYrIBrFd/Hx0M2Ocz6S111CaFkUcb0Q==",
        "name": "events",
        "url": "https://registry.npmjs.org/events/-/events-3.3.0.tgz",
    },
    "execa@5.1.1": {
        "deps": [
            {
                "id": "cross-spawn@7.0.3",
            },
            {
                "id": "get-stream@6.0.1",
            },
            {
                "id": "human-signals@2.1.0",
            },
            {
                "id": "is-stream@2.0.1",
            },
            {
                "id": "merge-stream@2.0.0",
            },
            {
                "id": "npm-run-path@4.0.1",
            },
            {
                "id": "onetime@5.1.2",
            },
            {
                "id": "signal-exit@3.0.7",
            },
            {
                "id": "strip-final-newline@2.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8uSpZZocAZRBAPIEINJj3Lo9HyGitllczc27Eh5YYojjMFMn8yHMDMaUHE2Jqfq05D/wucwI4JGURyXt1vchyg==",
        "name": "execa",
        "url": "https://registry.npmjs.org/execa/-/execa-5.1.1.tgz",
    },
    "exit@0.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-SF8Gygk5wo8YEokmxDRRYtCtz9NAxi4pK7gnws/oKkE=",
        "name": "exit",
        "url": "https://registry.npmjs.org/exit/-/exit-0.1.2.tgz",
    },
    "expect@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "jest-matcher-utils@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-E1q5hSUG2AmYQwQJ041nvgpkODHQvB+RKlB4IYdru6uJsyFTRyZAP463M+1lINorwbqAmUggi6+WwkD8lCS/Dw==",
        "name": "expect",
        "url": "https://registry.npmjs.org/expect/-/expect-27.5.1.tgz",
    },
    "fast-deep-equal@3.1.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==",
        "name": "fast-deep-equal",
        "url": "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz",
    },
    "fast-json-stable-stringify@2.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lhd/wF+Lk98HZoTCtlVraHtfh5XYijIjalXck7saUtuanSDyLMxnHhSXEDJqHxD7msR8D0uCmqlkwjCV8xvwHw==",
        "name": "fast-json-stable-stringify",
        "url": "https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz",
    },
    "fast-levenshtein@2.0.6": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-u0tQMGuLDwSEde/drhGBDiRZN9yoroVJirShcWl7vzw=",
        "name": "fast-levenshtein",
        "url": "https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz",
    },
    "fb-watchman@2.0.1": {
        "deps": [
            {
                "id": "bser@2.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-DkPJKQeY6kKwmuMretBhr7G6Vodr7bFwDYTXIkfG1gjvNpaxBTQV3PbXg6bR1c1UP4jPOX0jHUbbHANL9vRjVg==",
        "name": "fb-watchman",
        "url": "https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.1.tgz",
    },
    "file-entry-cache@6.0.1": {
        "deps": [
            {
                "id": "flat-cache@3.0.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7Gps/XWymbLk2QLYK4NzpMOrYjMhdIxXuIvy2QBsLE6ljuodKvdkWs/cpyJJ3CVIVpH0Oi1Hvg1ovbMzLdFBBg==",
        "name": "file-entry-cache",
        "url": "https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz",
    },
    "fill-range@7.0.1": {
        "deps": [
            {
                "id": "to-regex-range@5.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qOo9F+dMUmC2Lcb4BbVvnKJxTPjCm+RRpe4gDuGrzkL7mEVl/djYSu2OdQ2Pa302N4oqkSg9ir6jaLWJ2USVpQ==",
        "name": "fill-range",
        "url": "https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz",
    },
    "find-up@4.1.0": {
        "deps": [
            {
                "id": "locate-path@5.0.0",
            },
            {
                "id": "path-exists@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-PpOwAdQ/YlXQ2vj8a3h8IipDuYRi3wceVQQGYWxNINccq40Anw7BlsEXCMbt1Zt+OLA6Fq9suIpIWD0OsnISlw==",
        "name": "find-up",
        "url": "https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz",
    },
    "flat-cache@3.0.4": {
        "deps": [
            {
                "id": "flatted@3.2.5",
            },
            {
                "id": "rimraf@3.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-dm9s5Pw7Jc0GvMYbshN6zchCA9RgQlzzEZX3vylR9IqFfS8XciblUXOKfW6SiuJ0e13eDYZoZV5wdrev7P3Nwg==",
        "name": "flat-cache",
        "url": "https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz",
    },
    "flatted@3.2.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-WIWGi2L3DyTUvUrwRKgGi9TwxQMUEqPOPQBVi71R96jZXJdFskXEmf54BoZaS1kknGODoIGASGEzBUYdyMCBJg==",
        "name": "flatted",
        "url": "https://registry.npmjs.org/flatted/-/flatted-3.2.5.tgz",
    },
    "form-data@3.0.1": {
        "deps": [
            {
                "id": "asynckit@0.4.0",
            },
            {
                "id": "combined-stream@1.0.8",
            },
            {
                "id": "mime-types@2.1.34",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RHkBKtLWUVwd7SqRIvCZMEvAMoGUp0XU+seQiZejj0COz3RI3hWP4sCv3gZWWLjJTd7rGwcsF5eKZGii0r/hbg==",
        "name": "form-data",
        "url": "https://registry.npmjs.org/form-data/-/form-data-3.0.1.tgz",
    },
    "fs-constants@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-y6OAwoSIf7FyjMIv94u+b5rdheZEjzR63GTyZJm5qh4Bi+2YgwLCcI/fPFZkL5PSixOt6ZNKm+w+Hfp/Bciwow==",
        "name": "fs-constants",
        "url": "https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz",
    },
    "fs-minipass@2.1.0": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-V/JgOLFCS+R6Vcq0slCuaeWEdNC3ouDlJMNIsacH2VtALiu9mV4LPrHc5cDl8k5aw6J8jwgWWpiTo5RYhmIzvg==",
        "name": "fs-minipass",
        "url": "https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz",
    },
    "fs.realpath@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-noDLhxMSWqU9+BopYm97gfJqm+HNQYQLPM3K5NUuj5w=",
        "name": "fs.realpath",
        "url": "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz",
    },
    "fsevents@2.3.2": {
        "deps": [
            {
                "id": "node-gyp@8.4.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xiqMQR4xAeHTuB9uWm+fFRcIOgKBMiOBP+eXiyT7jsgVCq1bkVygt00oASowB7EdtpOHaaPgKt812P9ab+DDKA==",
        "name": "fsevents",
        "url": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz",
    },
    "function-bind@1.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yIovAzMX49sF8Yl58fSCWJ5svSLuaibPxXQJFLmBObTuCr0Mf1KiPopGM9NiFjiYBCbfaa2Fh6breQ6ANVTI0A==",
        "name": "function-bind",
        "url": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz",
    },
    "functional-red-black-tree@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-2ULfp2B3j4CjMdPoS0Rx6Or5il1DzQRD1gIvps90Xw0=",
        "name": "functional-red-black-tree",
        "url": "https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz",
    },
    "gauge@4.0.0": {
        "deps": [
            {
                "id": "ansi-regex@5.0.1",
            },
            {
                "id": "aproba@2.0.0",
            },
            {
                "id": "color-support@1.1.3",
            },
            {
                "id": "console-control-strings@1.1.0",
            },
            {
                "id": "has-unicode@2.0.1",
            },
            {
                "id": "signal-exit@3.0.7",
            },
            {
                "id": "string-width@4.2.3",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
            {
                "id": "wide-align@1.1.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-F8sU45yQpjQjxKkm1UOAhf0U/O0aFt//Fl7hsrNVto+patMHjs7dPI9mFOGUKbhrgKm0S3EjW3scMFuQmWSROw==",
        "name": "gauge",
        "url": "https://registry.npmjs.org/gauge/-/gauge-4.0.0.tgz",
    },
    "gensync@1.0.0-beta.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==",
        "name": "gensync",
        "url": "https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz",
    },
    "get-caller-file@2.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-DyFP3BM/3YHTQOCUL/w0OZHR0lpKeGrxotcHWcqNEdnltqFwXVfhEBQ94eIo34AfQpo0rGki4cyIiftY06h2Fg==",
        "name": "get-caller-file",
        "url": "https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz",
    },
    "get-package-type@0.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-pjzuKtY64GYfWizNAJ0fr9VqttZkNiK2iS430LtIHzjBEr6bX8Am2zm4sW4Ro5wjWW5cAlRL1qAMTcXbjNAO2Q==",
        "name": "get-package-type",
        "url": "https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz",
    },
    "get-stream@6.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ts6Wi+2j3jQjqi70w5AlN8DFnkSwC+MqmxEzdEALB2qXZYV3X/b1CTfgPLGJNMeAWxdPfU8FO1ms3NUfaHCPYg==",
        "name": "get-stream",
        "url": "https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz",
    },
    "glob-parent@6.0.2": {
        "deps": [
            {
                "id": "is-glob@4.0.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==",
        "name": "glob-parent",
        "url": "https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz",
    },
    "glob-to-regexp@0.4.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lkX1HJXwyMcprw/5YUZc2s7DrpAiHB21/V+E1rHUrVNokkvB6bqMzT0VfV6/86ZNabt1k14YOIaT7nDvOX3Iiw==",
        "name": "glob-to-regexp",
        "url": "https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz",
    },
    "glob@7.2.0": {
        "deps": [
            {
                "id": "fs.realpath@1.0.0",
            },
            {
                "id": "inflight@1.0.6",
            },
            {
                "id": "inherits@2.0.4",
            },
            {
                "id": "minimatch@3.0.5",
            },
            {
                "id": "once@1.4.0",
            },
            {
                "id": "path-is-absolute@1.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-lmLf6gtyrPq8tTjSmrO94wBeQbFR3HbLHbuyD69wuyQkImp2hWqMGB47OX65FBkPffO641IP9jWa1z4ivqG26Q==",
        "name": "glob",
        "url": "https://registry.npmjs.org/glob/-/glob-7.2.0.tgz",
    },
    "globals@11.12.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-WOBp/EEGUiIsJSp7wcv/y6MO+lV9UoncWqxuFfm8eBwzWNgyfBd6Gz+IeKQ9jCmyhoH99g15M3T+QaVHFjizVA==",
        "name": "globals",
        "url": "https://registry.npmjs.org/globals/-/globals-11.12.0.tgz",
    },
    "globals@13.12.1": {
        "deps": [
            {
                "id": "type-fest@0.20.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-317dFlgY2pdJZ9rspXDks7073GpDmXdfbM3vYYp0HAMKGDh1FfWPleI2ljVNLQX5M5lXcAslTcPTrOrMEFOjyw==",
        "name": "globals",
        "url": "https://registry.npmjs.org/globals/-/globals-13.12.1.tgz",
    },
    "graceful-fs@4.2.9": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-NtNxqUcXgpW2iMrfqSfR73Glt39K+BLwWsPs94yR63v45T0Wbej7eRmL5cWfwEgqXnmjQp3zaJTshdRW/qC2ZQ==",
        "name": "graceful-fs",
        "url": "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.9.tgz",
    },
    "has-flag@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-7UtxMiDcIq4C0GPCECJe4idKeQXJzX2wQbpu9RGp4Oo=",
        "name": "has-flag",
        "url": "https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz",
    },
    "has-flag@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==",
        "name": "has-flag",
        "url": "https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz",
    },
    "has-unicode@2.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-0GHdnymqfgY+/muumQboERqOK5tph2z06eIze3M17Kw=",
        "name": "has-unicode",
        "url": "https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz",
    },
    "has@1.0.3": {
        "deps": [
            {
                "id": "function-bind@1.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-f2dvO0VU6Oej7RkWJGrehjbzMAjFp5/VKPp5tTpWIV4JHHZK1/BxbFRtf/siA2SWTe09caDmVtYYzWEIbBS4zw==",
        "name": "has",
        "url": "https://registry.npmjs.org/has/-/has-1.0.3.tgz",
    },
    "html-encoding-sniffer@2.0.1": {
        "deps": [
            {
                "id": "whatwg-encoding@1.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-D5JbOMBIR/TVZkubHT+OyT2705QvogUW4IBn6nHd756OwieSF9aDYFj4dv6HHEVGYbHaLETa3WggZYWWMyy3ZQ==",
        "name": "html-encoding-sniffer",
        "url": "https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz",
    },
    "html-escaper@2.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-H2iMtd0I4Mt5eYiapRdIDjp+XzelXQ0tFE4JS7YFwFevXXMmOp9myNrUvCg0D6ws8iqkRPBfKHgbwig1SmlLfg==",
        "name": "html-escaper",
        "url": "https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz",
    },
    "http-cache-semantics@4.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-carPklcUh7ROWRK7Cv27RPtdhYhUsela/ue5/jKzjegVvXDqM2ILE9Q2BGn9JZJh1g87cp56su/FgQSzcWS8cQ==",
        "name": "http-cache-semantics",
        "url": "https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz",
    },
    "http-proxy-agent@4.0.1": {
        "deps": [
            {
                "id": "@tootallnate/once@1.1.2",
            },
            {
                "id": "agent-base@6.0.2",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-k0zdNgqWTGA6aeIRVpvfVob4fL52dTfaehylg0Y4UvSySvOq/Y+BOyPrgpUrA7HylqvU8vIZGsRuXmspskV0Tg==",
        "name": "http-proxy-agent",
        "url": "https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz",
    },
    "https-proxy-agent@5.0.0": {
        "deps": [
            {
                "id": "agent-base@6.0.2",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EkYm5BcKUGiduxzSt3Eppko+PiNWNEpa4ySk9vTC6wDsQJW9rHSa+UhGNJoRYp7bz6Ht1eaRIa6QaJqO5rCFbA==",
        "name": "https-proxy-agent",
        "url": "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.0.tgz",
    },
    "human-signals@2.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-B4FFZ6q/T2jhhksgkbEW3HBvWIfDW85snkQgawt07S7J5QXTk6BkNV+0yAeZrM5QpMAdYlocGoljn0sJ/WQkFw==",
        "name": "human-signals",
        "url": "https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz",
    },
    "humanize-ms@1.2.1": {
        "deps": [
            {
                "id": "ms@2.1.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-VA/m2yF5SXxmPY9rWZxu8IYtBSdI81iQogHvOidBXic=",
        "name": "humanize-ms",
        "url": "https://registry.npmjs.org/humanize-ms/-/humanize-ms-1.2.1.tgz",
    },
    "iconv-lite@0.4.24": {
        "deps": [
            {
                "id": "safer-buffer@2.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-v3MXnZAcvnywkTUEZomIActle7RXXeedOR31wwl7VlyoXO4Qi9arvSenNQWne1TcRwhCL1HwLI21bEqdpj8/rA==",
        "name": "iconv-lite",
        "url": "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz",
    },
    "iconv-lite@0.6.3": {
        "deps": [
            {
                "id": "safer-buffer@2.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4fCk79wshMdzMp2rH06qWrJE4iolqLhCUH+OiuIgU++RB0+94NlDL81atO7GX55uUKueo0txHNtvEyI6D7WdMw==",
        "name": "iconv-lite",
        "url": "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz",
    },
    "ieee754@1.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-dcyqhDvX1C46lXZcVqCpK+FtMRQVdIMN6/Df5js2zouUsqG7I6sFxitIC+7KYK29KdXOLHdu9zL4sFnoVQnqaA==",
        "name": "ieee754",
        "url": "https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz",
    },
    "ignore@4.0.6": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cyFDKrqc/YdcWFniJhzI42+AzS+gNwmUzOSFcRCQYwySuBBBy/KjuxWLZ/FHEH6Moq1NizMOBWyTcv8O4OZIMg==",
        "name": "ignore",
        "url": "https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz",
    },
    "import-fresh@3.3.0": {
        "deps": [
            {
                "id": "parent-module@1.0.1",
            },
            {
                "id": "resolve-from@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-veYYhQa+D1QBKznvhUHxb8faxlrwUnxseDAbAp457E0wLNio2bOSKnjYDhMj+YiAq61xrMGhQk9iXVk5FzgQMw==",
        "name": "import-fresh",
        "url": "https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz",
    },
    "import-local@3.1.0": {
        "deps": [
            {
                "id": "pkg-dir@4.2.0",
            },
            {
                "id": "resolve-cwd@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ASB07uLtnDs1o6EHjKpX34BKYDSqnFerfTOJL2HvMqF70LnxpjkzDB8J44oT9pu4AMPkQwf8jl6szgvNd2tRIg==",
        "name": "import-local",
        "url": "https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz",
    },
    "imurmurhash@0.1.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-rCOgMZZqc3HRkuNceFKrMcdyt9TkaN3Yhq08AUNyy2A=",
        "name": "imurmurhash",
        "url": "https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz",
    },
    "indent-string@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-EdDDZu4A2OyIK7Lr/2zG+w5jmbuk1DVBnEwREQvBzspBJkCEbRa8GxU1lghYcaGJCnRWibjDXlq779X1/y5xwg==",
        "name": "indent-string",
        "url": "https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz",
    },
    "infer-owner@1.0.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-IClj+Xz94+d7irH5qRyfJonOdfTzuDaifE6ZPWfx0N0+/ATZCbuTPq2prFl526urkQd90WyUKIh1DfBQ2hMz9A==",
        "name": "infer-owner",
        "url": "https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz",
    },
    "inflight@1.0.6": {
        "deps": [
            {
                "id": "once@1.4.0",
            },
            {
                "id": "wrappy@1.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-Wp/c9Zh0r2rTtBO2gV1a+q6jSTmjvuIOHlD3gwAxiJs=",
        "name": "inflight",
        "url": "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz",
    },
    "inherits@2.0.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==",
        "name": "inherits",
        "url": "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz",
    },
    "ip@1.1.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-qPaI2kxCxZjvdyxggQP98eoKvsFboIJFb7or3DIiQlk=",
        "name": "ip",
        "url": "https://registry.npmjs.org/ip/-/ip-1.1.5.tgz",
    },
    "is-arrayish@0.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-hI0V2T5EeJcmOmVMEUyORcNAzn/cG8huekSkxE8n44w=",
        "name": "is-arrayish",
        "url": "https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz",
    },
    "is-core-module@2.8.1": {
        "deps": [
            {
                "id": "has@1.0.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-SdNCUs284hr40hFTFP6l0IfZ/RSrMXF3qgoRHd3/79unUTvrFO/JoXwkGm+5J/Oe3E/b5GsnG330uUNgRpu1PA==",
        "name": "is-core-module",
        "url": "https://registry.npmjs.org/is-core-module/-/is-core-module-2.8.1.tgz",
    },
    "is-extglob@2.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-jF1ChhRq1i/BCWmBcAzhwioWdwiSb8oB+cp0+btQvBk=",
        "name": "is-extglob",
        "url": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
    },
    "is-fullwidth-code-point@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==",
        "name": "is-fullwidth-code-point",
        "url": "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz",
    },
    "is-generator-fn@2.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cTIB4yPYL/Grw0EaSzASzg6bBy9gqCofvWN8okThAYIxKJZC+udlRAmGbM0XLeniEJSs8uEgHPGuHSe1XsOLSQ==",
        "name": "is-generator-fn",
        "url": "https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-2.1.0.tgz",
    },
    "is-glob@4.0.3": {
        "deps": [
            {
                "id": "is-extglob@2.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
        "name": "is-glob",
        "url": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
    },
    "is-lambda@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-lBQbD5/EAzxw1V1/+qDxwsDWpk/D59genk/kqxlwzUE=",
        "name": "is-lambda",
        "url": "https://registry.npmjs.org/is-lambda/-/is-lambda-1.0.1.tgz",
    },
    "is-module@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-Ir+Zfk3utKKWgtQjXJq/6gsYOBC7ybqrHtyFivvCUSw=",
        "name": "is-module",
        "url": "https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz",
    },
    "is-number@7.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
        "name": "is-number",
        "url": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
    },
    "is-potential-custom-element-name@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-bCYeRA2rVibKZd+s2625gGnGF/t7DSqDs4dP7CrLA1m7jKWz6pps0LpYLJN8Q64HtmPKJ1hrN3nzPNKFEKOUiQ==",
        "name": "is-potential-custom-element-name",
        "url": "https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz",
    },
    "is-reference@1.2.1": {
        "deps": [
            {
                "id": "@types/estree@0.0.51",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-U82MsXXiFIrjCK4otLT+o2NA2Cd2g5MLoOVXUZjIOhLurrRxpEXzI8O0KZHr3IjLvlAH1kTPYSuqer5T9ZVBKQ==",
        "name": "is-reference",
        "url": "https://registry.npmjs.org/is-reference/-/is-reference-1.2.1.tgz",
    },
    "is-stream@2.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hFoiJiTl63nn+kstHGBtewWSKnQLpyb155KHheA1l39uvtO9nWIop1p3udqPcUd/xbF1VLMO4n7OI6p7RbngDg==",
        "name": "is-stream",
        "url": "https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz",
    },
    "is-typedarray@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-DVyXq3M4MqoAaSm5M97Nca902S3MhXY3hAy0dJbIOEU=",
        "name": "is-typedarray",
        "url": "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz",
    },
    "isexe@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-R8/ocuCI4oxTtzb+8wUyS1fMHPyfcqmw92n5JzHLg1k=",
        "name": "isexe",
        "url": "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz",
    },
    "istanbul-lib-coverage@3.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eOeJ5BHCmHYvQK7xt9GkdHuzuCGS1Y6g9Gvnx3Ym33fz/HpLRYxiS0wHNr+m/MBC8B647Xt608vCDEvhl9c6Mw==",
        "name": "istanbul-lib-coverage",
        "url": "https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.0.tgz",
    },
    "istanbul-lib-instrument@5.1.0": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/parser@7.17.0",
            },
            {
                "id": "@istanbuljs/schema@0.1.3",
            },
            {
                "id": "istanbul-lib-coverage@3.2.0",
            },
            {
                "id": "semver@6.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-czwUz525rkOFDJxfKK6mYfIs9zBKILyrZQxjz3ABhjQXhbhFsSbo1HW/BFcsDnfJYJWA6thRR5/TUY2qs5W99Q==",
        "name": "istanbul-lib-instrument",
        "url": "https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.1.0.tgz",
    },
    "istanbul-lib-report@3.0.0": {
        "deps": [
            {
                "id": "istanbul-lib-coverage@3.2.0",
            },
            {
                "id": "make-dir@3.1.0",
            },
            {
                "id": "supports-color@7.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wcdi+uAKzfiGT2abPpKZ0hSU1rGQjUQnLvtY5MpQ7QCTahD3VODhcu4wcfY1YtkGaDD5yuydOLINXsfbus9ROw==",
        "name": "istanbul-lib-report",
        "url": "https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz",
    },
    "istanbul-lib-source-maps@4.0.1": {
        "deps": [
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "istanbul-lib-coverage@3.2.0",
            },
            {
                "id": "source-map@0.6.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-n3s8EwkdFIJCG3BPKBYvskgXGoy88ARzvegkitk60NxRdwltLOTaH7CUiMRXvwYorl0Q712iEjcWB+fK/MrWVw==",
        "name": "istanbul-lib-source-maps",
        "url": "https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz",
    },
    "istanbul-reports@3.1.4": {
        "deps": [
            {
                "id": "html-escaper@2.0.2",
            },
            {
                "id": "istanbul-lib-report@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-r1/DshN4KSE7xWEknZLLLLDn5CJybV3nw01VTkp6D5jzLuELlcbudfj/eSQFvrKsJuTVCGnePO7ho82Nw9zzfw==",
        "name": "istanbul-reports",
        "url": "https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.4.tgz",
    },
    "jest-changed-files@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "execa@5.1.1",
            },
            {
                "id": "throat@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-buBLMiByfWGCoMsLLzGUUSpAmIAGnbR2KJoMN10ziLhOLvP4e0SlypHnAel8iqQXTrcbmfEY9sSqae5sgUsTvw==",
        "name": "jest-changed-files",
        "url": "https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-27.5.1.tgz",
    },
    "jest-circus@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "co@4.6.0",
            },
            {
                "id": "dedent@0.7.0",
            },
            {
                "id": "expect@27.5.1",
            },
            {
                "id": "is-generator-fn@2.1.0",
            },
            {
                "id": "jest-each@27.5.1",
            },
            {
                "id": "jest-matcher-utils@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "stack-utils@2.0.5",
            },
            {
                "id": "throat@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-D95R7x5UtlMA5iBYsOHFFbMD/GVA4R/Kdq15f7xYWUfWHBto9NYRsOvnSauTgdF+ogCpJ4tyKOXhUifxS65gdw==",
        "name": "jest-circus",
        "url": "https://registry.npmjs.org/jest-circus/-/jest-circus-27.5.1.tgz",
    },
    "jest-cli@27.5.1": {
        "deps": [
            {
                "id": "@jest/core@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "import-local@3.1.0",
            },
            {
                "id": "jest-config@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "prompts@2.4.2",
            },
            {
                "id": "yargs@16.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Hc6HOOwYq4/74/c62dEE3r5elx8wjYqxY0r0G/nFrLDPMFRu6RA/u8qINOIkvhxG7mMQ5EJsOGfRpI8L6eFUVw==",
        "name": "jest-cli",
        "url": "https://registry.npmjs.org/jest-cli/-/jest-cli-27.5.1.tgz",
    },
    "jest-cli@27.5.1-70c2be6d": {
        "deps": [
            {
                "id": "@jest/core@27.5.1-70c2be6d",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "exit@0.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "import-local@3.1.0",
            },
            {
                "id": "jest-config@27.5.1-1e8b1377",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "prompts@2.4.2",
            },
            {
                "id": "yargs@16.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Hc6HOOwYq4/74/c62dEE3r5elx8wjYqxY0r0G/nFrLDPMFRu6RA/u8qINOIkvhxG7mMQ5EJsOGfRpI8L6eFUVw==",
        "name": "jest-cli",
        "url": "https://registry.npmjs.org/jest-cli/-/jest-cli-27.5.1.tgz",
    },
    "jest-config@27.5.1": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@jest/test-sequencer@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "babel-jest@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "ci-info@3.3.0",
            },
            {
                "id": "deepmerge@4.2.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-circus@27.5.1",
            },
            {
                "id": "jest-environment-jsdom@27.5.1",
            },
            {
                "id": "jest-environment-node@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "jest-jasmine2@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-runner@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "parse-json@5.2.0",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "strip-json-comments@3.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5sAsjm6tGdsVbW9ahcChPAFCk4IlkQUknH5AvKjuLTSlcO/wCZKyFdn7Rg0EkC+OGgWODEy2hDpWB1PgzH0JNA==",
        "name": "jest-config",
        "url": "https://registry.npmjs.org/jest-config/-/jest-config-27.5.1.tgz",
    },
    "jest-config@27.5.1-1e8b1377": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@jest/test-sequencer@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "babel-jest@27.5.1-30a721e8",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "ci-info@3.3.0",
            },
            {
                "id": "deepmerge@4.2.2",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-circus@27.5.1",
            },
            {
                "id": "jest-environment-jsdom@27.5.1",
            },
            {
                "id": "jest-environment-node@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "jest-jasmine2@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-runner@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "parse-json@5.2.0",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "strip-json-comments@3.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5sAsjm6tGdsVbW9ahcChPAFCk4IlkQUknH5AvKjuLTSlcO/wCZKyFdn7Rg0EkC+OGgWODEy2hDpWB1PgzH0JNA==",
        "name": "jest-config",
        "url": "https://registry.npmjs.org/jest-config/-/jest-config-27.5.1.tgz",
    },
    "jest-diff@27.5.1": {
        "deps": [
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "diff-sequences@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-m0NvkX55LDt9T4mctTEgnZk3fmEg3NRYutvMPWM/0iPnkFj2wIeF45O1718cMSOFO1vINkqmxqD8vE37uTEbqw==",
        "name": "jest-diff",
        "url": "https://registry.npmjs.org/jest-diff/-/jest-diff-27.5.1.tgz",
    },
    "jest-docblock@27.5.1": {
        "deps": [
            {
                "id": "detect-newline@3.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rl7hlABeTsRYxKiUfpHrQrG4e2obOiTQWfMEH3PxPjOtdsfLQO4ReWSZaQ7DETm4xu07rl4q/h4zcKXyU0/OzQ==",
        "name": "jest-docblock",
        "url": "https://registry.npmjs.org/jest-docblock/-/jest-docblock-27.5.1.tgz",
    },
    "jest-each@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1Ff6p+FbhT/bXQnEouYy00bkNSY7OUpfIcmdl8vZ31A1UUaurOLPA8a8BbJOF2RDUElwJhmeaV7LnagI+5UwNQ==",
        "name": "jest-each",
        "url": "https://registry.npmjs.org/jest-each/-/jest-each-27.5.1.tgz",
    },
    "jest-environment-jsdom@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/fake-timers@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "jest-mock@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jsdom@16.7.0-de33b7f3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TFBvkTC1Hnnnrka/fUb56atfDtJ9VMZ94JkjTbggl1PEpwrYtUBKMezB3inLmWqQsXYLcMwNoDQwoBTAvFfsfw==",
        "name": "jest-environment-jsdom",
        "url": "https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-27.5.1.tgz",
    },
    "jest-environment-node@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/fake-timers@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "jest-mock@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Jt4ZUnxdOsTGwSRAfKEnE6BcwsSPNOijjwifq5sDFSA2kesnXTvNqKHYgM0hDq3549Uf/KzdXNYn4wMZJPlFLw==",
        "name": "jest-environment-node",
        "url": "https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-27.5.1.tgz",
    },
    "jest-get-type@27.5.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-2KY95ksYSaK7DMBWQn6dQz3kqAf3BB64y2udeG+hv4KfSOb9qwcYQstTJc1KCbsix+wLZWZYN8t7nwX3GOBLRw==",
        "name": "jest-get-type",
        "url": "https://registry.npmjs.org/jest-get-type/-/jest-get-type-27.5.1.tgz",
    },
    "jest-haste-map@27.4.6": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/graceful-fs@4.1.5",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "anymatch@3.1.2",
            },
            {
                "id": "fb-watchman@2.0.1",
            },
            {
                "id": "fsevents@2.3.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-serializer@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "walker@1.0.8",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0tNpgxg7BKurZeFkIOvGCkbmOHbLFf4LUQOxrQSMjvrQaQe3l6E8x6jYC1NuWkGo5WDdbr8FEzUxV2+LWNawKQ==",
        "name": "jest-haste-map",
        "url": "https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-27.4.6.tgz",
    },
    "jest-haste-map@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/graceful-fs@4.1.5",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "anymatch@3.1.2",
            },
            {
                "id": "fb-watchman@2.0.1",
            },
            {
                "id": "fsevents@2.3.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-serializer@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "walker@1.0.8",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7GgkZ4Fw4NFbMSDSpZwXeBiIbx+t/46nJ2QitkOjvwPYyZmqttu2TDSimMHP1EkPOi4xUZAN1doE5Vd25H4Jng==",
        "name": "jest-haste-map",
        "url": "https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-27.5.1.tgz",
    },
    "jest-jasmine2@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/source-map@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "co@4.6.0",
            },
            {
                "id": "expect@27.5.1",
            },
            {
                "id": "is-generator-fn@2.1.0",
            },
            {
                "id": "jest-each@27.5.1",
            },
            {
                "id": "jest-matcher-utils@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "throat@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-jtq7VVyG8SqAorDpApwiJJImd0V2wv1xzdheGHRGyuT7gZm6gG47QEskOlzsN1PG/6WNaCo5pmwMHDf3AkG2pQ==",
        "name": "jest-jasmine2",
        "url": "https://registry.npmjs.org/jest-jasmine2/-/jest-jasmine2-27.5.1.tgz",
    },
    "jest-junit@13.0.0": {
        "deps": [
            {
                "id": "mkdirp@1.0.4",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
            {
                "id": "uuid@8.3.2",
            },
            {
                "id": "xml@1.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JSHR+Dhb32FGJaiKkqsB7AR3OqWKtldLd6ZH2+FJ8D4tsweb8Id8zEVReU4+OlrRO1ZluqJLQEETm+Q6/KilBg==",
        "name": "jest-junit",
        "url": "https://registry.npmjs.org/jest-junit/-/jest-junit-13.0.0.tgz",
    },
    "jest-leak-detector@27.5.1": {
        "deps": [
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-POXfWAMvfU6WMUXftV4HolnJfnPOGEu10fscNCA76KBpRRhcMN2c8d3iT2pxQS3HLbA+5X4sOUPzYO2NUyIlHQ==",
        "name": "jest-leak-detector",
        "url": "https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-27.5.1.tgz",
    },
    "jest-matcher-utils@27.5.1": {
        "deps": [
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "jest-diff@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "pretty-format@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-z2uTx/T6LBaCoNWNFWwChLBKYxTMcGBRjAt+2SbP929/Fflb9aa5LGma654Rz8z9HLxsrUaYzxE9T/EFIL/PAw==",
        "name": "jest-matcher-utils",
        "url": "https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-27.5.1.tgz",
    },
    "jest-message-util@27.5.1": {
        "deps": [
            {
                "id": "@babel/code-frame@7.16.7",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/stack-utils@2.0.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "micromatch@4.0.4",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "stack-utils@2.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rMyFe1+jnyAAf+NHwTclDz0eAaLkVDdKVHHBFWsBWHnnh5YeJMNWWsv7AbFYXfK3oTqvL7VTWkhNLu1jX24D+g==",
        "name": "jest-message-util",
        "url": "https://registry.npmjs.org/jest-message-util/-/jest-message-util-27.5.1.tgz",
    },
    "jest-mock@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-K4jKbY1d4ENhbrG2zuPWaQBvDly+iZ2yAW+T1fATN78hc0sInwn7wZB8XtlNnvHug5RMwV897Xm4LqmPM4e2Og==",
        "name": "jest-mock",
        "url": "https://registry.npmjs.org/jest-mock/-/jest-mock-27.5.1.tgz",
    },
    "jest-pnp-resolver@1.2.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-olV41bKSMm8BdnuMsewT4jqlZ8+3TCARAXjZGT9jcoSnrfUnRCqnMoF9XEeoWjbzObpqF9dRhHQj0Xb9QdF6/w==",
        "name": "jest-pnp-resolver",
        "url": "https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.2.tgz",
    },
    "jest-pnp-resolver@1.2.2-a0a4a415": {
        "deps": [
        ],
        "extra_deps": {
            "@jest/core@27.5.1-70c2be6d": [
                {
                    "id": "@jest/reporters@27.5.1-1e8b1377",
                },
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "@jest/reporters@27.5.1-1e8b1377": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "jest-resolve@27.5.1": [
                {
                    "id": "jest-pnp-resolver@1.2.2-a0a4a415",
                },
            ],
            "jest-pnp-resolver@1.2.2-a0a4a415": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
        },
        "integrity": "sha512-olV41bKSMm8BdnuMsewT4jqlZ8+3TCARAXjZGT9jcoSnrfUnRCqnMoF9XEeoWjbzObpqF9dRhHQj0Xb9QdF6/w==",
        "name": "jest-pnp-resolver",
        "url": "https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.2.tgz",
    },
    "jest-regex-util@27.5.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4bfKq2zie+x16okqDXjXn9ql2B0dScQu+vcwe4TvFVhkVyuWLqpZrZtXxLLWoXYgn0E87I6r6GRYHF7wFZBUvg==",
        "name": "jest-regex-util",
        "url": "https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-27.5.1.tgz",
    },
    "jest-resolve-dependencies@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-QQOOdY4PE39iawDn5rzbIePNigfe5B9Z91GDD1ae/xNDlu9kaat8QQ5EKnNmVWPV54hUdxCVwwj6YMgR2O7IOg==",
        "name": "jest-resolve-dependencies",
        "url": "https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-27.5.1.tgz",
    },
    "jest-resolve@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-validate@27.5.1",
            },
            {
                "id": "resolve.exports@1.1.0",
            },
            {
                "id": "resolve@1.22.0",
            },
            {
                "id": "slash@3.0.0",
            },
        ],
        "extra_deps": {
            "@jest/core@27.5.1-70c2be6d": [
                {
                    "id": "@jest/reporters@27.5.1-1e8b1377",
                },
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "@jest/reporters@27.5.1-1e8b1377": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
            "jest-resolve@27.5.1": [
                {
                    "id": "jest-pnp-resolver@1.2.2-a0a4a415",
                },
            ],
            "jest-pnp-resolver@1.2.2-a0a4a415": [
                {
                    "id": "jest-resolve@27.5.1",
                },
            ],
        },
        "integrity": "sha512-FFDy8/9E6CV83IMbDpcjOhumAQPDyETnU2KZ1O98DwTnz8AOBsW/Xv3GySr1mOZdItLR+zDZ7I/UdTFbgSOVCw==",
        "name": "jest-resolve",
        "url": "https://registry.npmjs.org/jest-resolve/-/jest-resolve-27.5.1.tgz",
    },
    "jest-runner@27.5.1": {
        "deps": [
            {
                "id": "@jest/console@27.5.1",
            },
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "emittery@0.8.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-docblock@27.5.1",
            },
            {
                "id": "jest-environment-jsdom@27.5.1",
            },
            {
                "id": "jest-environment-node@27.5.1",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-leak-detector@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-runtime@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "source-map-support@0.5.21",
            },
            {
                "id": "throat@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-g4NPsM4mFCOwFKXO4p/H/kWGdJp9V8kURY2lX8Me2drgXqG7rrZAx5kv+5H7wtt/cdFIjhqYx1HrlqWHaOvDaQ==",
        "name": "jest-runner",
        "url": "https://registry.npmjs.org/jest-runner/-/jest-runner-27.5.1.tgz",
    },
    "jest-runtime@27.5.1": {
        "deps": [
            {
                "id": "@jest/environment@27.5.1",
            },
            {
                "id": "@jest/fake-timers@27.5.1",
            },
            {
                "id": "@jest/globals@27.5.1",
            },
            {
                "id": "@jest/source-map@27.5.1",
            },
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "cjs-module-lexer@1.2.2",
            },
            {
                "id": "collect-v8-coverage@1.0.1",
            },
            {
                "id": "execa@5.1.1",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-mock@27.5.1",
            },
            {
                "id": "jest-regex-util@27.5.1",
            },
            {
                "id": "jest-resolve@27.5.1",
            },
            {
                "id": "jest-snapshot@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "slash@3.0.0",
            },
            {
                "id": "strip-bom@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-o7gxw3Gf+H2IGt8fv0RiyE1+r83FJBRruoA+FXrlHw6xEyBsU8ugA6IPfTdVyA0w8HClpbK+DGJxH59UrNMx8A==",
        "name": "jest-runtime",
        "url": "https://registry.npmjs.org/jest-runtime/-/jest-runtime-27.5.1.tgz",
    },
    "jest-serializer@27.5.1": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-jZCyo6iIxO1aqUxpuBlwTDMkzOAJS4a3eYz3YzgxxVQFwLeSA7Jfq5cbqCY+JLvTDrWirgusI/0KwxKMgrdf7w==",
        "name": "jest-serializer",
        "url": "https://registry.npmjs.org/jest-serializer/-/jest-serializer-27.5.1.tgz",
    },
    "jest-snapshot@27.5.1": {
        "deps": [
            {
                "id": "@babel/core@7.17.2",
            },
            {
                "id": "@babel/generator@7.17.0",
            },
            {
                "id": "@babel/plugin-syntax-typescript@7.16.7-b26687be",
            },
            {
                "id": "@babel/traverse@7.17.0",
            },
            {
                "id": "@babel/types@7.17.0",
            },
            {
                "id": "@jest/transform@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/babel__traverse@7.14.2",
            },
            {
                "id": "@types/prettier@2.4.4",
            },
            {
                "id": "babel-preset-current-node-syntax@1.0.1-b26687be",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "expect@27.5.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "jest-diff@27.5.1",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "jest-haste-map@27.5.1",
            },
            {
                "id": "jest-matcher-utils@27.5.1",
            },
            {
                "id": "jest-message-util@27.5.1",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "natural-compare@1.4.0",
            },
            {
                "id": "pretty-format@27.5.1",
            },
            {
                "id": "semver@7.3.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-yYykXI5a0I31xX67mgeLw1DZ0bJB+gpq5IpSuCAoyDi0+BhgU/RIrL+RTzDmkNTchvDFWKP8lp+w/42Z3us5sA==",
        "name": "jest-snapshot",
        "url": "https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-27.5.1.tgz",
    },
    "jest-util@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "ci-info@3.3.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "picomatch@2.3.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Kv2o/8jNvX1MQ0KGtw480E/w4fBCDOnH6+6DmeKi6LZUIlKA5kwY0YNdlzaWTiVgxqAqik11QyxDOKk543aKXw==",
        "name": "jest-util",
        "url": "https://registry.npmjs.org/jest-util/-/jest-util-27.5.1.tgz",
    },
    "jest-validate@27.5.1": {
        "deps": [
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "camelcase@6.3.0",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "jest-get-type@27.5.1",
            },
            {
                "id": "leven@3.1.0",
            },
            {
                "id": "pretty-format@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-thkNli0LYTmOI1tDB3FI1S1RTp/Bqyd9pTarJwL87OIBFuqEb5Apv5EaApEudYg4g86e3CT6kM0RowkhtEnCBQ==",
        "name": "jest-validate",
        "url": "https://registry.npmjs.org/jest-validate/-/jest-validate-27.5.1.tgz",
    },
    "jest-watcher@27.5.1": {
        "deps": [
            {
                "id": "@jest/test-result@27.5.1",
            },
            {
                "id": "@jest/types@27.5.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "ansi-escapes@4.3.2",
            },
            {
                "id": "chalk@4.1.2",
            },
            {
                "id": "jest-util@27.5.1",
            },
            {
                "id": "string-length@4.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-z676SuD6Z8o8qbmEGhoEUFOM1+jfEiL3DXHK/xgEiG2EyNYfFG60jluWcupY6dATjfEsKQuibReS1djInQnoVw==",
        "name": "jest-watcher",
        "url": "https://registry.npmjs.org/jest-watcher/-/jest-watcher-27.5.1.tgz",
    },
    "jest-worker@27.5.1": {
        "deps": [
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "merge-stream@2.0.0",
            },
            {
                "id": "supports-color@8.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7vuh85V5cdDofPyxn58nrPjBktZo0u9x1g8WtjQol+jZDaE+fhN+cIvTj11GndBnMnyfrUOG1sZQxCdjKh+DKg==",
        "name": "jest-worker",
        "url": "https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz",
    },
    "jest@27.4.7": {
        "deps": [
            {
                "id": "@jest/core@27.5.1",
            },
            {
                "id": "import-local@3.1.0",
            },
            {
                "id": "jest-cli@27.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8heYvsx7nV/m8m24Vk26Y87g73Ba6ueUd0MWed/NXMhSZIm62U/llVbS0PJe1SHunbyXjJ/BqG1z9bFjGUIvTg==",
        "name": "jest",
        "url": "https://registry.npmjs.org/jest/-/jest-27.4.7.tgz",
    },
    "jest@27.4.7-dc3fc578": {
        "deps": [
            {
                "id": "@jest/core@27.5.1-70c2be6d",
            },
            {
                "id": "import-local@3.1.0",
            },
            {
                "id": "jest-cli@27.5.1-70c2be6d",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8heYvsx7nV/m8m24Vk26Y87g73Ba6ueUd0MWed/NXMhSZIm62U/llVbS0PJe1SHunbyXjJ/BqG1z9bFjGUIvTg==",
        "name": "jest",
        "url": "https://registry.npmjs.org/jest/-/jest-27.4.7.tgz",
    },
    "js-tokens@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==",
        "name": "js-tokens",
        "url": "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz",
    },
    "js-yaml@3.14.1": {
        "deps": [
            {
                "id": "argparse@1.0.10",
            },
            {
                "id": "esprima@4.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-okMH7OXXJ7YrN9Ok3/SXrnu4iX9yOk+25nqX4imS2npuvTYDmo/QEZoqwZkYaIDk3jVvBOTOIEgEhaLOynBS9g==",
        "name": "js-yaml",
        "url": "https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz",
    },
    "js-yaml@4.1.0": {
        "deps": [
            {
                "id": "argparse@2.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==",
        "name": "js-yaml",
        "url": "https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz",
    },
    "jsdom@16.7.0": {
        "deps": [
            {
                "id": "abab@2.0.5",
            },
            {
                "id": "acorn-globals@6.0.0",
            },
            {
                "id": "acorn@8.7.0",
            },
            {
                "id": "cssom@0.4.4",
            },
            {
                "id": "cssstyle@2.3.0",
            },
            {
                "id": "data-urls@2.0.0",
            },
            {
                "id": "decimal.js@10.3.1",
            },
            {
                "id": "domexception@2.0.1",
            },
            {
                "id": "escodegen@2.0.0",
            },
            {
                "id": "form-data@3.0.1",
            },
            {
                "id": "html-encoding-sniffer@2.0.1",
            },
            {
                "id": "http-proxy-agent@4.0.1",
            },
            {
                "id": "https-proxy-agent@5.0.0",
            },
            {
                "id": "is-potential-custom-element-name@1.0.1",
            },
            {
                "id": "nwsapi@2.2.0",
            },
            {
                "id": "parse5@6.0.1",
            },
            {
                "id": "saxes@5.0.1",
            },
            {
                "id": "symbol-tree@3.2.4",
            },
            {
                "id": "tough-cookie@4.0.0",
            },
            {
                "id": "w3c-hr-time@1.0.2",
            },
            {
                "id": "w3c-xmlserializer@2.0.0",
            },
            {
                "id": "webidl-conversions@6.1.0",
            },
            {
                "id": "whatwg-encoding@1.0.5",
            },
            {
                "id": "whatwg-mimetype@2.3.0",
            },
            {
                "id": "whatwg-url@8.7.0",
            },
            {
                "id": "ws@7.5.7",
            },
            {
                "id": "xml-name-validator@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-u9Smc2G1USStM+s/x1ru5Sxrl6mPYCbByG1U/hUmqaVsm4tbNyS7CicOSRyuGQYZhTu0h84qkZZQ/I+dzizSVw==",
        "name": "jsdom",
        "url": "https://registry.npmjs.org/jsdom/-/jsdom-16.7.0.tgz",
    },
    "jsdom@16.7.0-de33b7f3": {
        "deps": [
            {
                "id": "abab@2.0.5",
            },
            {
                "id": "acorn-globals@6.0.0",
            },
            {
                "id": "acorn@8.7.0",
            },
            {
                "id": "cssom@0.4.4",
            },
            {
                "id": "cssstyle@2.3.0",
            },
            {
                "id": "data-urls@2.0.0",
            },
            {
                "id": "decimal.js@10.3.1",
            },
            {
                "id": "domexception@2.0.1",
            },
            {
                "id": "escodegen@2.0.0",
            },
            {
                "id": "form-data@3.0.1",
            },
            {
                "id": "html-encoding-sniffer@2.0.1",
            },
            {
                "id": "http-proxy-agent@4.0.1",
            },
            {
                "id": "https-proxy-agent@5.0.0",
            },
            {
                "id": "is-potential-custom-element-name@1.0.1",
            },
            {
                "id": "nwsapi@2.2.0",
            },
            {
                "id": "parse5@6.0.1",
            },
            {
                "id": "saxes@5.0.1",
            },
            {
                "id": "symbol-tree@3.2.4",
            },
            {
                "id": "tough-cookie@4.0.0",
            },
            {
                "id": "w3c-hr-time@1.0.2",
            },
            {
                "id": "w3c-xmlserializer@2.0.0",
            },
            {
                "id": "webidl-conversions@6.1.0",
            },
            {
                "id": "whatwg-encoding@1.0.5",
            },
            {
                "id": "whatwg-mimetype@2.3.0",
            },
            {
                "id": "whatwg-url@8.7.0",
            },
            {
                "id": "ws@7.5.7-f91bf4c0",
            },
            {
                "id": "xml-name-validator@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-u9Smc2G1USStM+s/x1ru5Sxrl6mPYCbByG1U/hUmqaVsm4tbNyS7CicOSRyuGQYZhTu0h84qkZZQ/I+dzizSVw==",
        "name": "jsdom",
        "url": "https://registry.npmjs.org/jsdom/-/jsdom-16.7.0.tgz",
    },
    "jsesc@2.5.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OYu7XEzjkCQ3C5Ps3QIZsQfNpqoJyZZA99wd9aWd05NCtC5pWOkShK2mkL6HXQR6/Cy2lbNdPlZBpuQHXE63gA==",
        "name": "jsesc",
        "url": "https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz",
    },
    "json-parse-better-errors@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-mrqyZKfX5EhL7hvqcV6WG1yYjnjeuYDzDhhcAAUrq8Po85NBQBJP+ZDUT75qZQ98IkUoBqdkExkukOU7Ts2wrw==",
        "name": "json-parse-better-errors",
        "url": "https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz",
    },
    "json-parse-even-better-errors@2.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xyFwyhro/JEof6Ghe2iz2NcXoj2sloNsWr/XsERDK/oiPCfaNhl5ONfp+jQdAZRQQ0IJWNzH9zIZF7li91kh2w==",
        "name": "json-parse-even-better-errors",
        "url": "https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz",
    },
    "json-schema-traverse@0.4.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg==",
        "name": "json-schema-traverse",
        "url": "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz",
    },
    "json-stable-stringify-without-jsonify@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-Xb1grIWLjrn7ghnNDb6Jy4ZkBXScuskML4vBisx3ruo=",
        "name": "json-stable-stringify-without-jsonify",
        "url": "https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz",
    },
    "json5@2.2.0": {
        "deps": [
            {
                "id": "minimist@1.2.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-f+8cldu7X/y7RAJurMEJmdoKXGB/X550w2Nr3tTbezL6RwEE/iMcm+tZnXeoZtKuOq6ft8+CqzEkrIgx1fPoQA==",
        "name": "json5",
        "url": "https://registry.npmjs.org/json5/-/json5-2.2.0.tgz",
    },
    "kleur@3.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eTIzlVOSUR+JxdDFepEYcBMtZ9Qqdef+rnzWdRZuMbOywu5tO2w2N7rqjoANZ5k9vywhL6Br1VRjUIgTQx4E8w==",
        "name": "kleur",
        "url": "https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz",
    },
    "leven@3.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qsda+H8jTaUaN/x5vzW2rzc+8Rw4TAQ/4KjB46IwK5VH+IlVeeeje/EoZRpiXvIqjFgK84QffqPztGI3VBLG1A==",
        "name": "leven",
        "url": "https://registry.npmjs.org/leven/-/leven-3.1.0.tgz",
    },
    "levn@0.3.0": {
        "deps": [
            {
                "id": "prelude-ls@1.1.2",
            },
            {
                "id": "type-check@0.3.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-ugE+hY2FsA70WxqrzpIXEPAt8Ps2AA3BfmPKwWhxliQ=",
        "name": "levn",
        "url": "https://registry.npmjs.org/levn/-/levn-0.3.0.tgz",
    },
    "levn@0.4.1": {
        "deps": [
            {
                "id": "prelude-ls@1.2.1",
            },
            {
                "id": "type-check@0.4.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+bT2uH4E5LGE7h/n3evcS/sQlJXCpIp6ym8OWJ5eV6+67Dsql/LaaT7qJBAt2rzfoa/5QBGBhxDix1dMt2kQKQ==",
        "name": "levn",
        "url": "https://registry.npmjs.org/levn/-/levn-0.4.1.tgz",
    },
    "lines-and-columns@1.2.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==",
        "name": "lines-and-columns",
        "url": "https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz",
    },
    "loader-runner@4.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-92+huvxMvYlMzMt0iIOukcwYBFpkYJdpl2xsZ7LrlayO7E8SOv+JJUEK17B/dJIHAOLMfh2dZZ/Y18WgmGtYNw==",
        "name": "loader-runner",
        "url": "https://registry.npmjs.org/loader-runner/-/loader-runner-4.2.0.tgz",
    },
    "locate-path@5.0.0": {
        "deps": [
            {
                "id": "p-locate@4.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-t7hw9pI+WvuwNJXwk5zVHpyhIqzg2qTlklJOf0mVxGSbe3Fp2VieZcduNYjaLDoy6p9uGpQEGWG87WpMKlNq8g==",
        "name": "locate-path",
        "url": "https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz",
    },
    "lodash.merge@4.6.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0KpjqXRVvrYyCsX1swR/XTK0va6VQkQM6MNo7PqW77ByjAhoARA8EfrP1N4+KlKj8YS0ZUCtRT/YUuhyYDujIQ==",
        "name": "lodash.merge",
        "url": "https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz",
    },
    "lodash@4.17.21": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==",
        "name": "lodash",
        "url": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
    },
    "long@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XsP+KhQif4bjX1kbuSiySJFNAehNxgLb6hPRGJ9QsUr8ajHkuXGdrHmFUTUUXhDwVX2R5bY4JNZEwbUiMhV+MA==",
        "name": "long",
        "url": "https://registry.npmjs.org/long/-/long-4.0.0.tgz",
    },
    "lru-cache@6.0.0": {
        "deps": [
            {
                "id": "yallist@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==",
        "name": "lru-cache",
        "url": "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz",
    },
    "magic-string@0.25.7": {
        "deps": [
            {
                "id": "sourcemap-codec@1.4.8",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4CrMT5DOHTDk4HYDlzmwu4FVCcIYI8gauveasrdCu2IKIFOJ3f0v/8MDGJCDL9oD2ppz/Av1b0Nj345H9M+XIA==",
        "name": "magic-string",
        "url": "https://registry.npmjs.org/magic-string/-/magic-string-0.25.7.tgz",
    },
    "make-dir@3.1.0": {
        "deps": [
            {
                "id": "semver@6.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-g3FeP20LNwhALb/6Cz6Dd4F2ngze0jz7tbzrD2wAV+o9FeNHe4rL+yK2md0J/fiSf1sa1ADhXqi5+oVwOM/eGw==",
        "name": "make-dir",
        "url": "https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz",
    },
    "make-fetch-happen@9.1.0": {
        "deps": [
            {
                "id": "agentkeepalive@4.2.0",
            },
            {
                "id": "cacache@15.3.0",
            },
            {
                "id": "http-cache-semantics@4.1.0",
            },
            {
                "id": "http-proxy-agent@4.0.1",
            },
            {
                "id": "https-proxy-agent@5.0.0",
            },
            {
                "id": "is-lambda@1.0.1",
            },
            {
                "id": "lru-cache@6.0.0",
            },
            {
                "id": "minipass-collect@1.0.2",
            },
            {
                "id": "minipass-fetch@1.4.1",
            },
            {
                "id": "minipass-flush@1.0.5",
            },
            {
                "id": "minipass-pipeline@1.2.4",
            },
            {
                "id": "minipass@3.1.6",
            },
            {
                "id": "negotiator@0.6.3",
            },
            {
                "id": "promise-retry@2.0.1",
            },
            {
                "id": "socks-proxy-agent@6.1.1",
            },
            {
                "id": "ssri@8.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+zopwDy7DNknmwPQplem5lAZX/eCOzSvSNNcSKm5eVwTkOBzoktEfXsa9L23J/GIRhxRsaxzkPEhrJEpE2F4Gg==",
        "name": "make-fetch-happen",
        "url": "https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-9.1.0.tgz",
    },
    "makeerror@1.0.12": {
        "deps": [
            {
                "id": "tmpl@1.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JmqCvUhmt43madlpFzG4BQzG2Z3m6tvQDNKdClZnO3VbIudJYmxsT0FNJMeiB2+JTSlTQTSbU8QdesVmwJcmLg==",
        "name": "makeerror",
        "url": "https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz",
    },
    "merge-stream@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-abv/qOcuPfk3URPfDzmZU1LKmuw8kT+0nIHvKrKgFrwifol/doWcdA4ZqsWQ8ENrFKkd67Mfpo/LovbIUsbt3w==",
        "name": "merge-stream",
        "url": "https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz",
    },
    "micromatch@4.0.4": {
        "deps": [
            {
                "id": "braces@3.0.2",
            },
            {
                "id": "picomatch@2.3.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-pRmzw/XUcwXGpD9aI9q/0XOwLNygjETJ8y0ao0wdqprrzDa4YnxLcz7fQRZr8voh8V10kGhABbNcHVk5wHgWwg==",
        "name": "micromatch",
        "url": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.4.tgz",
    },
    "mime-db@1.51.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5y8A56jg7XVQx2mbv1lu49NR4dokRnhZYTtL+KGfaa27uq4pSTXkwQkFJl4pkRMyNFz/EtYDSkiiEHx3F7UN6g==",
        "name": "mime-db",
        "url": "https://registry.npmjs.org/mime-db/-/mime-db-1.51.0.tgz",
    },
    "mime-types@2.1.34": {
        "deps": [
            {
                "id": "mime-db@1.51.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6cP692WwGIs9XXdOO4++N+7qjqv0rqxxVvJ3VHPh/Sc9mVZcQP+ZGhkKiTvWMQRr2tbHkJP/Yn7Y0npb3ZBs4A==",
        "name": "mime-types",
        "url": "https://registry.npmjs.org/mime-types/-/mime-types-2.1.34.tgz",
    },
    "mimic-fn@2.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OqbOk5oEQeAZ8WXWydlu9HJjz9WVdEIvamMCcXmuqUYjTknH/sqsWvhQ3vgwKFRR1HpjvNBKQ37nbJgYzGqGcg==",
        "name": "mimic-fn",
        "url": "https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz",
    },
    "minimatch@3.0.5": {
        "deps": [
            {
                "id": "brace-expansion@1.1.11",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tUpxzX0VAzJHjLu0xUfFv1gwVp9ba3IOuRAVH2EGuRW8a5emA2FlACLqiT/lDVtS1W+TGNwqz3sWaNyLgDJWuw==",
        "name": "minimatch",
        "url": "https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz",
    },
    "minimist@1.2.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-FM9nNUYrRBAELZQT3xeZQ7fmMOBg6nWNmJKTcgsJeaLstP/UODVpGsr5OhXhhXg6f+qtJ8uiZ+PUxkDWcgIXLw==",
        "name": "minimist",
        "url": "https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz",
    },
    "minipass-collect@1.0.2": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6T6lH0H8OG9kITm/Jm6tdooIbogG9e0tLgpY6mphXSm/A9u8Nq1ryBG+Qspiub9LjWlBPsPS3tWQ/Botq4FdxA==",
        "name": "minipass-collect",
        "url": "https://registry.npmjs.org/minipass-collect/-/minipass-collect-1.0.2.tgz",
    },
    "minipass-fetch@1.4.1": {
        "deps": [
            {
                "id": "encoding@0.1.13",
            },
            {
                "id": "minipass-sized@1.0.3",
            },
            {
                "id": "minipass@3.1.6",
            },
            {
                "id": "minizlib@2.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-CGH1eblLq26Y15+Azk7ey4xh0J/XfJfrCox5LDJiKqI2Q2iwOLOKrlmIaODiSQS8d18jalF6y2K2ePUm0CmShw==",
        "name": "minipass-fetch",
        "url": "https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-1.4.1.tgz",
    },
    "minipass-flush@1.0.5": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JmQSYYpPUqX5Jyn1mXaRwOda1uQ8HP5KAT/oDSLCzt1BYRhQU0/hDtsB1ufZfEEzMZ9aAVmsBw8+FWsIXlClWw==",
        "name": "minipass-flush",
        "url": "https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz",
    },
    "minipass-pipeline@1.2.4": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xuIq7cIOt09RPRJ19gdi4b+RiNvDFYe5JH+ggNvBqGqpQXcru3PcRmOZuHBKWK1Txf9+cQ+HMVN4d6z46LZP7A==",
        "name": "minipass-pipeline",
        "url": "https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz",
    },
    "minipass-sized@1.0.3": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-MbkQQ2CTiBMlA2Dm/5cY+9SWFEN8pzzOXi6rlM5Xxq0Yqbda5ZQy9sU75a673FE9ZK0Zsbr6Y5iP6u9nktfg2g==",
        "name": "minipass-sized",
        "url": "https://registry.npmjs.org/minipass-sized/-/minipass-sized-1.0.3.tgz",
    },
    "minipass@3.1.6": {
        "deps": [
            {
                "id": "yallist@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rty5kpw9/z8SX9dmxblFA6edItUmwJgMeYDZRrwlIVN27i8gysGbznJwUggw2V/FVqFSDdWy040ZPS811DYAqQ==",
        "name": "minipass",
        "url": "https://registry.npmjs.org/minipass/-/minipass-3.1.6.tgz",
    },
    "minizlib@2.1.2": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
            {
                "id": "yallist@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-bAxsR8BVfj60DWXHE3u30oHzfl4G7khkSuPW+qvpd7jFRHm7dLxOjUk1EHACJ/hxLY8phGJ0YhYHZo7jil7Qdg==",
        "name": "minizlib",
        "url": "https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz",
    },
    "mkdirp@1.0.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vVqVZQyf3WLx2Shd0qJ9xuvqgAyKPLAiqITEtqW0oIUjzo3PePDd6fW9iFz30ef7Ysp/oiWqbhszeGWW2T6Gzw==",
        "name": "mkdirp",
        "url": "https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz",
    },
    "ms@2.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-sGkPx+VjMtmA6MX27oA4FBFELFCZZ4S4XqeGOXCv68tT+jb3vk/RyaKWP0PTKyWtmLSM0b+adUTEvbs1PEaH2w==",
        "name": "ms",
        "url": "https://registry.npmjs.org/ms/-/ms-2.1.2.tgz",
    },
    "ms@2.1.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
        "name": "ms",
        "url": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
    },
    "natural-compare@1.4.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-XlVp7NEgZPc2MqjBikWx0d5KJ7aZpnGGSAHxw17nee4=",
        "name": "natural-compare",
        "url": "https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz",
    },
    "negotiator@0.6.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+EUsqGPLsM+j/zdChZjsnX51g4XrHFOIXwfnCVPGlQk/k5giakcKsuxCObBRu6DSm9opw/O6slWbJdghQM4bBg==",
        "name": "negotiator",
        "url": "https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz",
    },
    "neo-async@2.6.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Yd3UES5mWCSqR+qNT93S3UoYUkqAZ9lLg8a7g9rimsWmYGK8cVToA4/sF3RrshdyV3sAGMXVUmpMYOw+dLpOuw==",
        "name": "neo-async",
        "url": "https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz",
    },
    "node-fetch@2.6.7": {
        "deps": [
            {
                "id": "whatwg-url@5.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZjMPFEfVx5j+y2yF35Kzx5sF7kDzxuDj6ziH4FFbOp87zKDZNx8yExJIb05OGF4Nlt9IHFIMBkRl41VdvcNdbQ==",
        "name": "node-fetch",
        "url": "https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz",
    },
    "node-fetch@2.6.7-dc3fc578": {
        "deps": [
            {
                "id": "whatwg-url@5.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ZjMPFEfVx5j+y2yF35Kzx5sF7kDzxuDj6ziH4FFbOp87zKDZNx8yExJIb05OGF4Nlt9IHFIMBkRl41VdvcNdbQ==",
        "name": "node-fetch",
        "url": "https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz",
    },
    "node-gyp@8.4.1": {
        "deps": [
            {
                "id": "env-paths@2.2.1",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "make-fetch-happen@9.1.0",
            },
            {
                "id": "nopt@5.0.0",
            },
            {
                "id": "npmlog@6.0.1",
            },
            {
                "id": "rimraf@3.0.2",
            },
            {
                "id": "semver@7.3.5",
            },
            {
                "id": "tar@6.1.11",
            },
            {
                "id": "which@2.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-olTJRgUtAb/hOXG0E93wZDs5YiJlgbXxTwQAFHyNlRsXQnYzUaF2aGgujZbw+hR8aF4ZG/rST57bWMWD16jr9w==",
        "name": "node-gyp",
        "url": "https://registry.npmjs.org/node-gyp/-/node-gyp-8.4.1.tgz",
    },
    "node-int64@0.4.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-JQJiiTfIlZReLO6kj/RTxIErNcKicKTvuT/3eowPIlc=",
        "name": "node-int64",
        "url": "https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz",
    },
    "node-releases@2.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XxYDdcQ6eKqp/YjI+tb2C5WM2LgjnZrfYg4vgQt49EK268b6gYCHsBLrK2qvJo4FmCtqmKezb0WZFK4fkrZNsg==",
        "name": "node-releases",
        "url": "https://registry.npmjs.org/node-releases/-/node-releases-2.0.2.tgz",
    },
    "nopt@5.0.0": {
        "deps": [
            {
                "id": "abbrev@1.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Tbj67rffqceeLpcRXrT7vKAN8CwfPeIBgM7E6iBkmKLV7bEMwpGgYLGv0jACUsECaa/vuxP0IjEont6umdMgtQ==",
        "name": "nopt",
        "url": "https://registry.npmjs.org/nopt/-/nopt-5.0.0.tgz",
    },
    "normalize-path@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==",
        "name": "normalize-path",
        "url": "https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz",
    },
    "npm-run-path@4.0.1": {
        "deps": [
            {
                "id": "path-key@3.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-S48WzZW777zhNIrn7gxOlISNAqi9ZC/uQFnRdbeIHhZhCA6UqpkOT8T1G7BvfdgP4Er8gF4sUbaS0i7QvIfCWw==",
        "name": "npm-run-path",
        "url": "https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz",
    },
    "npmlog@6.0.1": {
        "deps": [
            {
                "id": "are-we-there-yet@3.0.0",
            },
            {
                "id": "console-control-strings@1.1.0",
            },
            {
                "id": "gauge@4.0.0",
            },
            {
                "id": "set-blocking@2.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-BTHDvY6nrRHuRfyjt1MAufLxYdVXZfd099H4+i1f0lPywNQyI4foeNXJRObB/uy+TYqUW0vAD9gbdSOXPst7Eg==",
        "name": "npmlog",
        "url": "https://registry.npmjs.org/npmlog/-/npmlog-6.0.1.tgz",
    },
    "nwsapi@2.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-h2AatdwYH+JHiZpv7pt/gSX1XoRGb7L/qSIeuqA6GwYoF9w1vP1cw42TO0aI2pNyshRK5893hNSl+1//vHK7hQ==",
        "name": "nwsapi",
        "url": "https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.0.tgz",
    },
    "object-hash@1.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OSuu/pU4ENM9kmREg0BdNrUDIl1heYa4mBZacJc+vVWz4GtAwu7jO8s4AIt2aGRUTqxykpWzI3Oqnsm13tTMDA==",
        "name": "object-hash",
        "url": "https://registry.npmjs.org/object-hash/-/object-hash-1.3.1.tgz",
    },
    "once@1.4.0": {
        "deps": [
            {
                "id": "wrappy@1.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-z1FGC6Nwxpj2i5duUU0RNJczm6AYtgA+jo61acb8z88=",
        "name": "once",
        "url": "https://registry.npmjs.org/once/-/once-1.4.0.tgz",
    },
    "onetime@5.1.2": {
        "deps": [
            {
                "id": "mimic-fn@2.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-kbpaSSGJTWdAY5KPVeMOKXSrPtr8C8C7wodJbcsd51jRnmD+GZu8Y0VoU6Dm5Z4vWr0Ig/1NKuWRKf7j5aaYSg==",
        "name": "onetime",
        "url": "https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz",
    },
    "optionator@0.8.3": {
        "deps": [
            {
                "id": "deep-is@0.1.4",
            },
            {
                "id": "fast-levenshtein@2.0.6",
            },
            {
                "id": "levn@0.3.0",
            },
            {
                "id": "prelude-ls@1.1.2",
            },
            {
                "id": "type-check@0.3.2",
            },
            {
                "id": "word-wrap@1.2.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+IW9pACdk3XWmmTXG8m3upGUJst5XRGzxMRjXzAuJ1XnIFNvfhjjIuYkDvysnPQ7qzqVzLt78BCruntqRhWQbA==",
        "name": "optionator",
        "url": "https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz",
    },
    "optionator@0.9.1": {
        "deps": [
            {
                "id": "deep-is@0.1.4",
            },
            {
                "id": "fast-levenshtein@2.0.6",
            },
            {
                "id": "levn@0.4.1",
            },
            {
                "id": "prelude-ls@1.2.1",
            },
            {
                "id": "type-check@0.4.0",
            },
            {
                "id": "word-wrap@1.2.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-74RlY5FCnhq4jRxVUPKDaRwrVNXMqsGsiW6AJw4XK8hmtm10wC0ypZBLw5IIp85NZMr91+qd1RvvENwg7jjRFw==",
        "name": "optionator",
        "url": "https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz",
    },
    "p-limit@2.3.0": {
        "deps": [
            {
                "id": "p-try@2.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-//88mFWSJx8lxCzwdAABTJL2MyWB12+eIY7MDL2SqLmAkeKU9qxRvWuSyTjm3FUmpBEMuFfckAIqEaVGUDxb6w==",
        "name": "p-limit",
        "url": "https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz",
    },
    "p-locate@4.1.0": {
        "deps": [
            {
                "id": "p-limit@2.3.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-R79ZZ/0wAxKGu3oYMlz8jy/kbhsNrS7SKZ7PxEHBgJ5+F2mtFW2fK2cOtBh1cHYkQsbzFV7I+EoRKe6Yt0oK7A==",
        "name": "p-locate",
        "url": "https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz",
    },
    "p-map@4.0.0": {
        "deps": [
            {
                "id": "aggregate-error@3.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/bjOqmgETBYB5BoEeGVea8dmvHb2m9GLy1E9W43yeyfP6QQCZGFNa+XRceJEuDB6zqr+gKpIAmlLebMpykw/MQ==",
        "name": "p-map",
        "url": "https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz",
    },
    "p-try@2.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-R4nPAVTAU0B9D35/Gk3uJf/7XYbQcyohSKdvAxIRSNghFl4e71hVoGnBNQz9cWaXxO2I10KTC+3jMdvvoKw6dQ==",
        "name": "p-try",
        "url": "https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz",
    },
    "parent-module@1.0.1": {
        "deps": [
            {
                "id": "callsites@3.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GQ2EWRpQV8/o+Aw8YqtfZZPfNRWZYkbidE9k5rpl/hC3vtHHBfGm2Ifi6qWV+coDGkrUKZAxE3Lot5kcsRlh+g==",
        "name": "parent-module",
        "url": "https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz",
    },
    "parse-json@5.2.0": {
        "deps": [
            {
                "id": "@babel/code-frame@7.16.7",
            },
            {
                "id": "error-ex@1.3.2",
            },
            {
                "id": "json-parse-even-better-errors@2.3.1",
            },
            {
                "id": "lines-and-columns@1.2.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ayCKvm/phCGxOkYRSCM82iDwct8/EonSEgCSxWxD7ve6jHggsFl4fZVQBPRNgQoKiuV/odhFrGzQXZwbifC8Rg==",
        "name": "parse-json",
        "url": "https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz",
    },
    "parse5@6.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Ofn/CTFzRGTTxwpNEs9PP93gXShHcTq255nzRYSKe8AkVpZY7e1fpmTfOyoIvjP5HG7Z2ZM7VS9PPhQGW2pOpw==",
        "name": "parse5",
        "url": "https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz",
    },
    "path-exists@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==",
        "name": "path-exists",
        "url": "https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz",
    },
    "path-is-absolute@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-bm1wnxpWlCUU5OLCcJswx7H/pG++1w5xSQSj1jsB91w=",
        "name": "path-is-absolute",
        "url": "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz",
    },
    "path-key@3.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==",
        "name": "path-key",
        "url": "https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz",
    },
    "path-parse@1.0.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==",
        "name": "path-parse",
        "url": "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz",
    },
    "picocolors@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-1fygroTLlHu66zi26VoTDv8yRgm0Fccecssto+MhsZ0D/DGW2sm8E8AjW7NU5VVTRt5GxbeZ5qBuJr+HyLYkjQ==",
        "name": "picocolors",
        "url": "https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz",
    },
    "picomatch@2.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JU3teHTNjmE2VCGFzuY8EXzCDVwEqB2a8fsIvwaStHhAWJEeVd1o1QD80CU6+ZdEXXSLbSsuLwJjkCBWqRQUVA==",
        "name": "picomatch",
        "url": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz",
    },
    "pirates@4.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8V9+HQPupnaXMA23c5hvl69zXvTwTzyAYasnkb0Tts4XvO4CliqONMOnvlq26rkhLC3nWDFBJf73LU1e1VZLaQ==",
        "name": "pirates",
        "url": "https://registry.npmjs.org/pirates/-/pirates-4.0.5.tgz",
    },
    "pkg-dir@4.2.0": {
        "deps": [
            {
                "id": "find-up@4.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-HRDzbaKjC+AOWVXxAU/x54COGeIv9eb+6CkDSQoNTt4XyWoIJvuPsXizxu/Fr23EiekbtZwmh1IcIG/l/a10GQ==",
        "name": "pkg-dir",
        "url": "https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz",
    },
    "prelude-ls@1.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-+v2P5NzHeMJxHN03H4/UZBizm5DjCh1K5YYPRRPmW1c=",
        "name": "prelude-ls",
        "url": "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz",
    },
    "prelude-ls@1.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vkcDPrRZo1QZLbn5RLGPpg/WmIQ65qoWWhcGKf/b5eplkkarX0m9z8ppCat4mlOqUsWpyNuYgO3VRyrYHSzX5g==",
        "name": "prelude-ls",
        "url": "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz",
    },
    "prettier@2.5.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vBZcPRUR5MZJwoyi3ZoyQlc1rXeEck8KgeC9AwwOn+exuxLxq5toTRDTSaVrXHxelDMHy9zlicw8u66yxoSUFg==",
        "name": "prettier",
        "url": "https://registry.npmjs.org/prettier/-/prettier-2.5.1.tgz",
    },
    "pretty-format@27.5.1": {
        "deps": [
            {
                "id": "ansi-regex@5.0.1",
            },
            {
                "id": "ansi-styles@5.2.0",
            },
            {
                "id": "react-is@17.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Qb1gy5OrP5+zDf2Bvnzdl3jsTf1qXVMazbvCoKhtKqVs4/YK4ozX4gKQJJVyNe+cajNPn0KoC0MC3FUmaHWEmQ==",
        "name": "pretty-format",
        "url": "https://registry.npmjs.org/pretty-format/-/pretty-format-27.5.1.tgz",
    },
    "progress@2.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7PiHtLll5LdnKIMw100I+8xJXR5gW2QwWYkT6iJva0bXitZKa/XMrSbdmg3r2Xnaidz9Qumd0VPaMrZlF9V9sA==",
        "name": "progress",
        "url": "https://registry.npmjs.org/progress/-/progress-2.0.3.tgz",
    },
    "promise-inflight@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-lMM7Zbyy47eKe1A/IC0Sx5ZF84zhLwLp6L7CvpfBKwo=",
        "name": "promise-inflight",
        "url": "https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz",
    },
    "promise-inflight@1.0.1-a7e5239c": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-lMM7Zbyy47eKe1A/IC0Sx5ZF84zhLwLp6L7CvpfBKwo=",
        "name": "promise-inflight",
        "url": "https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz",
    },
    "promise-retry@2.0.1": {
        "deps": [
            {
                "id": "err-code@2.0.3",
            },
            {
                "id": "retry@0.12.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-y+WKFlBR8BGXnsNlIHFGPZmyDf3DFMoLhaflAnyZgV6rG6xu+JwesTo2Q9R6XwYmtmwAFCkAk3e35jEdoeh/3g==",
        "name": "promise-retry",
        "url": "https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz",
    },
    "prompts@2.4.2": {
        "deps": [
            {
                "id": "kleur@3.0.3",
            },
            {
                "id": "sisteransi@1.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-NxNv/kLguCA7p3jE8oL2aEBsrJWgAakBpgmgK6lpPWV+WuOmY6r2/zbAVnP+T8bQlA0nzHXSJSJW0Hq7ylaD2Q==",
        "name": "prompts",
        "url": "https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz",
    },
    "protobufjs@6.11.2": {
        "deps": [
            {
                "id": "@protobufjs/aspromise@1.1.2",
            },
            {
                "id": "@protobufjs/base64@1.1.2",
            },
            {
                "id": "@protobufjs/codegen@2.0.4",
            },
            {
                "id": "@protobufjs/eventemitter@1.1.0",
            },
            {
                "id": "@protobufjs/fetch@1.1.0",
            },
            {
                "id": "@protobufjs/float@1.0.2",
            },
            {
                "id": "@protobufjs/inquire@1.1.0",
            },
            {
                "id": "@protobufjs/path@1.1.2",
            },
            {
                "id": "@protobufjs/pool@1.1.0",
            },
            {
                "id": "@protobufjs/utf8@1.1.0",
            },
            {
                "id": "@types/long@4.0.1",
            },
            {
                "id": "@types/node@17.0.17",
            },
            {
                "id": "long@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4BQJoPooKJl2G9j3XftkIXjoC9C0Av2NOrWmbLWT1vH32GcSUHjM0Arra6UfTsVyfMAuFzaLucXn1sadxJydAw==",
        "name": "protobufjs",
        "url": "https://registry.npmjs.org/protobufjs/-/protobufjs-6.11.2.tgz",
    },
    "psl@1.8.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-RIdOzyoavK+hA18OGGWDqUTsCLhtA7IcZ/6NCs4fFJaHBDab+pDDmDIByWFRQJq2Cd7r1OoQxBGKOaztq+hjIQ==",
        "name": "psl",
        "url": "https://registry.npmjs.org/psl/-/psl-1.8.0.tgz",
    },
    "punycode@2.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XRsRjdf+j5ml+y/6GKHPZbrF/8p2Yga0JPtdqTIY2Xe5ohJPD9saDJJLPvp9+NSBprVvevdXZybnj2cv8OEd0A==",
        "name": "punycode",
        "url": "https://registry.npmjs.org/punycode/-/punycode-2.1.1.tgz",
    },
    "randombytes@2.1.0": {
        "deps": [
            {
                "id": "safe-buffer@5.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-vYl3iOX+4CKUWuxGi9Ukhie6fsqXqS9FE2Zaic4tNFD2N2QQaXOMFbuKK4QmDHC0JO6B1Zp41J0LpT0oR68amQ==",
        "name": "randombytes",
        "url": "https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz",
    },
    "react-is@17.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-w2GsyukL62IJnlaff/nRegPQR94C/XXamvMWmSHRJ4y7Ts/4ocGRmTHvOs8PSE6pB3dWOrD/nueuU5sduBsQ4w==",
        "name": "react-is",
        "url": "https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz",
    },
    "readable-stream@3.6.0": {
        "deps": [
            {
                "id": "inherits@2.0.4",
            },
            {
                "id": "string_decoder@1.3.0",
            },
            {
                "id": "util-deprecate@1.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-BViHy7LKeTz4oNnkcLJ+lVSL6vpiFeX6/d3oSH8zCW7UxP2onchk+vTGB143xuFjHS3deTgkKoXXymXqymiIdA==",
        "name": "readable-stream",
        "url": "https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.0.tgz",
    },
    "regexpp@3.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-pq2bWo9mVD43nbts2wGv17XLiNLya+GklZ8kaDLV2Z08gDCsGpnKn9BFMepvWuHCbyVvY7J5o5+BVvoQbmlJLg==",
        "name": "regexpp",
        "url": "https://registry.npmjs.org/regexpp/-/regexpp-3.2.0.tgz",
    },
    "require-directory@2.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-cDvuCEQ2A4P+SoeS1KWlYmR0JqBT51l6HScqxVTzhsg=",
        "name": "require-directory",
        "url": "https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz",
    },
    "resolve-cwd@3.0.0": {
        "deps": [
            {
                "id": "resolve-from@5.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-OrZaX2Mb+rJCpH/6CpSqt9xFVpN++x01XnN2ie9g6P5/3xelLAkXWVADpdz1IHD/KFfEXyE6V0U01OQ3UO2rEg==",
        "name": "resolve-cwd",
        "url": "https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz",
    },
    "resolve-from@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-pb/MYmXstAkysRFx8piNI1tGFNQIFA3vkE3Gq4EuA1dF6gHp/+vgZqsCGJapvy8N3Q+4o7FwvquPJcnZ7RYy4g==",
        "name": "resolve-from",
        "url": "https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz",
    },
    "resolve-from@5.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qYg9KP24dD5qka9J47d0aVky0N+b4fTU89LN9iDnjB5waksiC49rvMB0PrUJQGoTmH50XPiqOvAjDfaijGxYZw==",
        "name": "resolve-from",
        "url": "https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz",
    },
    "resolve.exports@1.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-J1l+Zxxp4XK3LUDZ9m60LRJF/mAe4z6a4xyabPHk7pvK5t35dACV32iIjJDFeWZFfZlO29w6SZ67knR0tHzJtQ==",
        "name": "resolve.exports",
        "url": "https://registry.npmjs.org/resolve.exports/-/resolve.exports-1.1.0.tgz",
    },
    "resolve@1.22.0": {
        "deps": [
            {
                "id": "is-core-module@2.8.1",
            },
            {
                "id": "path-parse@1.0.7",
            },
            {
                "id": "supports-preserve-symlinks-flag@1.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Hhtrw0nLeSrFQ7phPp4OOcVjLPIeMnRlr5mcnVuMe7M/7eBn98A3hmFRLoFo3DLZkivSYwhRUJTyPyWAk56WLw==",
        "name": "resolve",
        "url": "https://registry.npmjs.org/resolve/-/resolve-1.22.0.tgz",
    },
    "retry@0.12.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-32HG0Zeq3Gqxe0iRA1M7uwIjQTVY1CIkEcFiFVwwtCg=",
        "name": "retry",
        "url": "https://registry.npmjs.org/retry/-/retry-0.12.0.tgz",
    },
    "rimraf@3.0.2": {
        "deps": [
            {
                "id": "glob@7.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JZkJMZkAGFFPP2YqXZXPbMlMBgsxzE8ILs4lMIX/2o0L9UBw9O/Y3o6wFw/i9YLapcUJWwqbi3kdxIPdC62TIA==",
        "name": "rimraf",
        "url": "https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz",
    },
    "rollup@2.58.3": {
        "deps": [
            {
                "id": "fsevents@2.3.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ei27MSw1KhRur4p87Q0/Va2NAYqMXOX++FNEumMBcdreIRLURKy+cE2wcDJKBn0nfmhP2ZGrJkP1XPO+G8FJQw==",
        "name": "rollup",
        "url": "https://registry.npmjs.org/rollup/-/rollup-2.58.3.tgz",
    },
    "safe-buffer@5.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Gd2UZBJDkXlY7GbJxfsE8/nvKkUEU1G38c1siN6QP6a9PT9MmHB8GnpscSmMJSoF8LOIrt8ud/wPtojys4G6+g==",
        "name": "safe-buffer",
        "url": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz",
    },
    "safe-buffer@5.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==",
        "name": "safe-buffer",
        "url": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz",
    },
    "safer-buffer@2.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==",
        "name": "safer-buffer",
        "url": "https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz",
    },
    "saxes@5.0.1": {
        "deps": [
            {
                "id": "xmlchars@2.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-5LBh1Tls8c9xgGjw3QrMwETmTMVk0oFgvrFSvWx62llR2hcEInrKNZ2GZCCuuy2lvWrdl5jhbpeqc5hRYKFOcw==",
        "name": "saxes",
        "url": "https://registry.npmjs.org/saxes/-/saxes-5.0.1.tgz",
    },
    "schema-utils@3.1.1": {
        "deps": [
            {
                "id": "@types/json-schema@7.0.9",
            },
            {
                "id": "ajv-keywords@3.5.2-87046475",
            },
            {
                "id": "ajv@6.12.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Y5PQxS4ITlC+EahLuXaY86TXfR7Dc5lw294alXOq86JAHCihAIZfqv8nNCWvaEJvaC51uN9hbLGeV0cFBdH+Fw==",
        "name": "schema-utils",
        "url": "https://registry.npmjs.org/schema-utils/-/schema-utils-3.1.1.tgz",
    },
    "semver@6.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-b39TBaTSfV6yBrapU89p5fKekE2m/NwnDocOVruQFS1/veMgdzuPcnOM34M6CwxW8jH/lxEa5rBoDeUwu5HHTw==",
        "name": "semver",
        "url": "https://registry.npmjs.org/semver/-/semver-6.3.0.tgz",
    },
    "semver@7.3.5": {
        "deps": [
            {
                "id": "lru-cache@6.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-PoeGJYh8HK4BTO/a9Tf6ZG3veo/A7ZVsYrSA6J8ny9nb3B1VrpkuN+z9OE5wfE5p6H4LchYZsegiQgbJD94ZFQ==",
        "name": "semver",
        "url": "https://registry.npmjs.org/semver/-/semver-7.3.5.tgz",
    },
    "serialize-javascript@6.0.0": {
        "deps": [
            {
                "id": "randombytes@2.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Qr3TosvguFt8ePWqsvRfrKyQXIiW+nGbYpy8XK24NQHE83caxWt+mIymTT19DGFbNWNLfEwsrkSmN64lVWB9ag==",
        "name": "serialize-javascript",
        "url": "https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.0.tgz",
    },
    "set-blocking@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-2TSu59ueCdoJ6HckdDMV/+iIEwqm4E+73srJhfauaT0=",
        "name": "set-blocking",
        "url": "https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz",
    },
    "shebang-command@2.0.0": {
        "deps": [
            {
                "id": "shebang-regex@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==",
        "name": "shebang-command",
        "url": "https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz",
    },
    "shebang-regex@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==",
        "name": "shebang-regex",
        "url": "https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz",
    },
    "signal-exit@3.0.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wnD2ZE+l+SPC/uoS0vXeE9L1+0wuaMqKlfz9AMUo38JsyLSBWSFcHR1Rri62LZc12vLr1gb3jl7iwQhgwpAbGQ==",
        "name": "signal-exit",
        "url": "https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz",
    },
    "sisteransi@1.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-bLGGlR1QxBcynn2d5YmDX4MGjlZvy2MRBDRNHLJ8VI6l6+9FUiyTFNJ0IveOSP0bcXgVDPRcfGqA0pjaqUpfVg==",
        "name": "sisteransi",
        "url": "https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz",
    },
    "slash@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-g9Q1haeby36OSStwb4ntCGGGaKsaVSjQ68fBxoQcutl5fS1vuY18H3wSt3jFyFtrkx+Kz0V1G85A4MyAdDMi2Q==",
        "name": "slash",
        "url": "https://registry.npmjs.org/slash/-/slash-3.0.0.tgz",
    },
    "smart-buffer@4.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-94hK0Hh8rPqQl2xXc3HsaBoOXKV20MToPkcXvwbISWLEs+64sBq5kFgn2kJDHb1Pry9yrP0dxrCI9RRci7RXKg==",
        "name": "smart-buffer",
        "url": "https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz",
    },
    "socks-proxy-agent@6.1.1": {
        "deps": [
            {
                "id": "agent-base@6.0.2",
            },
            {
                "id": "debug@4.3.3-66eebb2b",
            },
            {
                "id": "socks@2.6.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-t8J0kG3csjA4g6FTbsMOWws+7R7vuRC8aQ/wy3/1OWmsgwA68zs/+cExQ0koSitUDXqhufF/YJr9wtNMZHw5Ew==",
        "name": "socks-proxy-agent",
        "url": "https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-6.1.1.tgz",
    },
    "socks@2.6.2": {
        "deps": [
            {
                "id": "ip@1.1.5",
            },
            {
                "id": "smart-buffer@4.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-zDZhHhZRY9PxRruRMR7kMhnf3I8hDs4S3f9RecfnGxvcBHQcKcIH/oUcEWffsfl1XxdYlA7nnlGbbTvPz9D8gA==",
        "name": "socks",
        "url": "https://registry.npmjs.org/socks/-/socks-2.6.2.tgz",
    },
    "source-map-support@0.5.21": {
        "deps": [
            {
                "id": "buffer-from@1.1.2",
            },
            {
                "id": "source-map@0.6.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-uBHU3L3czsIyYXKX88fdrGovxdSCoTGDRZ6SYXtSRxLZUzHg5P/66Ht6uoUlHu9EZod+inXhKo3qQgwXUT/y1w==",
        "name": "source-map-support",
        "url": "https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz",
    },
    "source-map@0.5.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-4d4om8STFU8AoRy042PguzdhlTfUSza4ESu6SSQRa2c=",
        "name": "source-map",
        "url": "https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz",
    },
    "source-map@0.6.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-UjgapumWlbMhkBgzT7Ykc5YXUT46F0iKu8SGXq0bcwP5dz/h0Plj6enJqjz1Zbq2l5WaqYnrVbwWOWMyF3F47g==",
        "name": "source-map",
        "url": "https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz",
    },
    "source-map@0.7.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-CkCj6giN3S+n9qrYiBTX5gystlENnRW5jZeNLHpe6aue+SrHcG5VYwujhW9s4dY31mEGsxBDrHR6oI69fTXsaQ==",
        "name": "source-map",
        "url": "https://registry.npmjs.org/source-map/-/source-map-0.7.3.tgz",
    },
    "sourcemap-codec@1.4.8": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9NykojV5Uih4lgo5So5dtw+f0JgJX30KCNI8gwhz2J9A15wD0Ml6tjHKwf6fTSa6fAdVBdZeNOs9eJ71qCk8vA==",
        "name": "sourcemap-codec",
        "url": "https://registry.npmjs.org/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz",
    },
    "sprintf-js@1.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-OvsmvMMo3JD1FlFazyeDrTWwjb/p4K2hgmTDxN2qGoM=",
        "name": "sprintf-js",
        "url": "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz",
    },
    "ssri@8.0.1": {
        "deps": [
            {
                "id": "minipass@3.1.6",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-97qShzy1AiyxvPNIkLWoGua7xoQzzPjQ0HAH4B0rWKo7SZ6USuPcrUiAFrws0UH8RrbWmgq3LMTObhPIHbbBeQ==",
        "name": "ssri",
        "url": "https://registry.npmjs.org/ssri/-/ssri-8.0.1.tgz",
    },
    "stack-utils@2.0.5": {
        "deps": [
            {
                "id": "escape-string-regexp@2.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-xrQcmYhOsn/1kX+Vraq+7j4oE2j/6BFscZ0etmYg81xuM8Gq0022Pxb8+IqgOFUIaxHs0KaSb7T1+OegiNrNFA==",
        "name": "stack-utils",
        "url": "https://registry.npmjs.org/stack-utils/-/stack-utils-2.0.5.tgz",
    },
    "string-length@4.0.2": {
        "deps": [
            {
                "id": "char-regex@1.0.2",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+l6rNN5fYHNhZZy41RXsYptCjA2Igmq4EG7kZAYFQI1E1VTXarr6ZPXBg6eq7Y6eK4FEhY6AJlyuFIb/v/S0VQ==",
        "name": "string-length",
        "url": "https://registry.npmjs.org/string-length/-/string-length-4.0.2.tgz",
    },
    "string-width@4.2.3": {
        "deps": [
            {
                "id": "emoji-regex@8.0.0",
            },
            {
                "id": "is-fullwidth-code-point@3.0.0",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
        "name": "string-width",
        "url": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
    },
    "string_decoder@1.3.0": {
        "deps": [
            {
                "id": "safe-buffer@5.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-hkRX8U1WjJFd8LsDJ2yQ/wWWxaopEsABU1XfkM8A+j0+85JAGppt16cr1Whg6KIbb4okU6Mql6BOj+uup/wKeA==",
        "name": "string_decoder",
        "url": "https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz",
    },
    "strip-ansi@6.0.1": {
        "deps": [
            {
                "id": "ansi-regex@5.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
        "name": "strip-ansi",
        "url": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
    },
    "strip-bom@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-3xurFv5tEgii33Zi8Jtp55wEIILR9eh34FAW00PZf+JnSsTmV/ioewSgQl97JHvgjoRGwPShsWm+IdrxB35d0w==",
        "name": "strip-bom",
        "url": "https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz",
    },
    "strip-final-newline@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-BrpvfNAE3dcvq7ll3xVumzjKjZQ5tI1sEUIKr3Uoks0XUl45St3FlatVqef9prk4jRDzhW6WZg+3bk93y6pLjA==",
        "name": "strip-final-newline",
        "url": "https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz",
    },
    "strip-json-comments@3.1.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6fPc+R4ihwqP6N/aIv2f1gMH8lOVtWQHoqC4yK6oSDVVocumAsfCqjkXnqiYMhmMwS/mEHLp7Vehlt3ql6lEig==",
        "name": "strip-json-comments",
        "url": "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz",
    },
    "supports-color@5.5.0": {
        "deps": [
            {
                "id": "has-flag@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==",
        "name": "supports-color",
        "url": "https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz",
    },
    "supports-color@7.2.0": {
        "deps": [
            {
                "id": "has-flag@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==",
        "name": "supports-color",
        "url": "https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz",
    },
    "supports-color@8.1.1": {
        "deps": [
            {
                "id": "has-flag@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-MpUEN2OodtUzxvKQl72cUF7RQ5EiHsGvSsVG0ia9c5RbWGL2CI4C7EpPS8UTBIplnlzZiNuV56w+FuNxy3ty2Q==",
        "name": "supports-color",
        "url": "https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz",
    },
    "supports-hyperlinks@2.2.0": {
        "deps": [
            {
                "id": "has-flag@4.0.0",
            },
            {
                "id": "supports-color@7.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-6sXEzV5+I5j8Bmq9/vUphGRM/RJNT9SCURJLjwfOg51heRtguGWDzcaBlgAzKhQa0EVNpPEKzQuBwZ8S8WaCeQ==",
        "name": "supports-hyperlinks",
        "url": "https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-2.2.0.tgz",
    },
    "supports-preserve-symlinks-flag@1.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==",
        "name": "supports-preserve-symlinks-flag",
        "url": "https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz",
    },
    "symbol-tree@3.2.4": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-9QNk5KwDF+Bvz+PyObkmSYjI5ksVUYtjW7AU22r2NKcfLJcXp96hkDWU3+XndOsUb+AQ9QhfzfCT2O+CNWT5Tw==",
        "name": "symbol-tree",
        "url": "https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz",
    },
    "tapable@2.2.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GNzQvQTOIP6RyTfE2Qxb8ZVlNmw0n88vp1szwWRimP02mnTsx3Wtn5qRdqY9w2XduFNUgvOwhNnQsjwCp+kqaQ==",
        "name": "tapable",
        "url": "https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz",
    },
    "tar-stream@2.2.0": {
        "deps": [
            {
                "id": "bl@4.1.0",
            },
            {
                "id": "end-of-stream@1.4.4",
            },
            {
                "id": "fs-constants@1.0.0",
            },
            {
                "id": "inherits@2.0.4",
            },
            {
                "id": "readable-stream@3.6.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ujeqbceABgwMZxEJnk2HDY2DlnUZ+9oEcb1KzTVfYHio0UE6dG71n60d8D2I4qNvleWrrXpmjpt7vZeF1LnMZQ==",
        "name": "tar-stream",
        "url": "https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz",
    },
    "tar@6.1.11": {
        "deps": [
            {
                "id": "chownr@2.0.0",
            },
            {
                "id": "fs-minipass@2.1.0",
            },
            {
                "id": "minipass@3.1.6",
            },
            {
                "id": "minizlib@2.1.2",
            },
            {
                "id": "mkdirp@1.0.4",
            },
            {
                "id": "yallist@4.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-an/KZQzQUkZCkuoAA64hM92X0Urb6VpRhAFllDzz44U2mcD5scmT3zBc4VgVpkugF580+DQn8eAFSyoQt0tznA==",
        "name": "tar",
        "url": "https://registry.npmjs.org/tar/-/tar-6.1.11.tgz",
    },
    "terminal-link@2.1.1": {
        "deps": [
            {
                "id": "ansi-escapes@4.3.2",
            },
            {
                "id": "supports-hyperlinks@2.2.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-un0FmiRUQNr5PJqy9kP7c40F5BOfpGlYTrxonDChEZB7pzZxRNp/bt+ymiy9/npwXya9KH99nJ/GXFIiUkYGFQ==",
        "name": "terminal-link",
        "url": "https://registry.npmjs.org/terminal-link/-/terminal-link-2.1.1.tgz",
    },
    "terser-webpack-plugin@5.3.1": {
        "deps": [
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "schema-utils@3.1.1",
            },
            {
                "id": "serialize-javascript@6.0.0",
            },
            {
                "id": "source-map@0.6.1",
            },
            {
                "id": "terser@5.10.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-GvlZdT6wPQKbDNW/GDQzZFg/j4vKU96yl2q6mcUkzKOgW4gwf1Z8cZToUCrz31XHlPWH8MVb1r2tFtdDtTGJ7g==",
        "name": "terser-webpack-plugin",
        "url": "https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.1.tgz",
    },
    "terser-webpack-plugin@5.3.1-e30e60ed": {
        "deps": [
            {
                "id": "jest-worker@27.5.1",
            },
            {
                "id": "schema-utils@3.1.1",
            },
            {
                "id": "serialize-javascript@6.0.0",
            },
            {
                "id": "source-map@0.6.1",
            },
            {
                "id": "terser@5.10.0-00b92a9c",
            },
        ],
        "extra_deps": {
            "terser-webpack-plugin@5.3.1-e30e60ed": [
                {
                    "id": "webpack@5.64.4-dc3fc578",
                },
            ],
            "webpack@5.64.4-dc3fc578": [
                {
                    "id": "terser-webpack-plugin@5.3.1-e30e60ed",
                },
            ],
        },
        "integrity": "sha512-GvlZdT6wPQKbDNW/GDQzZFg/j4vKU96yl2q6mcUkzKOgW4gwf1Z8cZToUCrz31XHlPWH8MVb1r2tFtdDtTGJ7g==",
        "name": "terser-webpack-plugin",
        "url": "https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.1.tgz",
    },
    "terser@5.10.0": {
        "deps": [
            {
                "id": "commander@2.20.3",
            },
            {
                "id": "source-map-support@0.5.21",
            },
            {
                "id": "source-map@0.7.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AMmF99DMfEDiRJfxfY5jj5wNH/bYO09cniSqhfoyxc8sFoYIgkJy86G04UoZU5VjlpnplVu0K6Tx6E9b5+DlHA==",
        "name": "terser",
        "url": "https://registry.npmjs.org/terser/-/terser-5.10.0.tgz",
    },
    "terser@5.10.0-00b92a9c": {
        "deps": [
            {
                "id": "commander@2.20.3",
            },
            {
                "id": "source-map-support@0.5.21",
            },
            {
                "id": "source-map@0.7.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AMmF99DMfEDiRJfxfY5jj5wNH/bYO09cniSqhfoyxc8sFoYIgkJy86G04UoZU5VjlpnplVu0K6Tx6E9b5+DlHA==",
        "name": "terser",
        "url": "https://registry.npmjs.org/terser/-/terser-5.10.0.tgz",
    },
    "test-exclude@6.0.0": {
        "deps": [
            {
                "id": "@istanbuljs/schema@0.1.3",
            },
            {
                "id": "glob@7.2.0",
            },
            {
                "id": "minimatch@3.0.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-cAGWPIyOHU6zlmg88jwm7VRyXnMN7iV68OGAbYDk/Mh/xC/pzVPlQtY6ngoIH/5/tciuhGfvESU8GrHrcxD56w==",
        "name": "test-exclude",
        "url": "https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz",
    },
    "text-table@0.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-2IP2cEwGA3OZFwGJSTHdhZ9zk43RWcZgkiR6QD+Ix3I=",
        "name": "text-table",
        "url": "https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz",
    },
    "throat@6.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-8hmiGIJMDlwjg7dlJ4yKGLK8EsYqKgPWbG3b4wjJddKNwc7N7Dpn08Df4szr/sZdMVeOstrdYSsqzX6BYbcB+w==",
        "name": "throat",
        "url": "https://registry.npmjs.org/throat/-/throat-6.0.1.tgz",
    },
    "tmpl@1.0.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-3f0uOEAQwIqGuWW2MVzYg8fV/QNnc/IpuJNG837rLuczAaLVHslWHZQj4IGiEl5Hs3kkbhwL9Ab7Hrsmuj+Smw==",
        "name": "tmpl",
        "url": "https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz",
    },
    "to-fast-properties@2.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-xxP+SLwkP7BQXfxm8Mn9qK7JyYwVK4DPRNRZNF9OCYM=",
        "name": "to-fast-properties",
        "url": "https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz",
    },
    "to-regex-range@5.0.1": {
        "deps": [
            {
                "id": "is-number@7.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
        "name": "to-regex-range",
        "url": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
    },
    "tough-cookie@4.0.0": {
        "deps": [
            {
                "id": "psl@1.8.0",
            },
            {
                "id": "punycode@2.1.1",
            },
            {
                "id": "universalify@0.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-tHdtEpQCMrc1YLrMaqXXcj6AxhYi/xgit6mZu1+EDWUn+qhUf8wMQoFIy9NXuq23zAwtcB0t/MjACGR18pcRbg==",
        "name": "tough-cookie",
        "url": "https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.0.0.tgz",
    },
    "tr46@0.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-Fkrh6zLOo1NVG7x/k1jcquT/q75l7DepLKRkqVcKKgo=",
        "name": "tr46",
        "url": "https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz",
    },
    "tr46@2.1.0": {
        "deps": [
            {
                "id": "punycode@2.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-15Ih7phfcdP5YxqiB+iDtLoaTz4Nd35+IiAv0kQ5FNKHzXgdWqPoTIqEDDJmXceQt4JZk6lVPT8lnDlPpGDppw==",
        "name": "tr46",
        "url": "https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz",
    },
    "ts-poet@4.10.0": {
        "deps": [
            {
                "id": "lodash@4.17.21",
            },
            {
                "id": "prettier@2.5.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-V5xzt+LDMVtxWvK12WVwHhGHTA//CeoPdWOqka0mMjlRqq7RPKYSfWEnzJdMmhNbd34BwZuZpip4mm+nqEcbQA==",
        "name": "ts-poet",
        "url": "https://registry.npmjs.org/ts-poet/-/ts-poet-4.10.0.tgz",
    },
    "ts-proto-descriptors@1.6.0": {
        "deps": [
            {
                "id": "long@4.0.0",
            },
            {
                "id": "protobufjs@6.11.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Vrhue2Ti99us/o76mGy28nF3W/Uanl1/8detyJw2yyRwiBC5yxy+hEZqQ/ZX2PbZ1vyCpJ51A9L4PnCCnkBMTQ==",
        "name": "ts-proto-descriptors",
        "url": "https://registry.npmjs.org/ts-proto-descriptors/-/ts-proto-descriptors-1.6.0.tgz",
    },
    "ts-proto@1.83.3": {
        "deps": [
            {
                "id": "@types/object-hash@1.3.4",
            },
            {
                "id": "dataloader@1.4.0",
            },
            {
                "id": "object-hash@1.3.1",
            },
            {
                "id": "protobufjs@6.11.2",
            },
            {
                "id": "ts-poet@4.10.0",
            },
            {
                "id": "ts-proto-descriptors@1.6.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-r6MKFjoc4Og2kB4cNJ/bddLebdIwhouG5plu0Rry1jJMEqp2GKA7AE4FrR/FnTCIGbNPYP4622lBqckZd7UHcQ==",
        "name": "ts-proto",
        "url": "https://registry.npmjs.org/ts-proto/-/ts-proto-1.83.3.tgz",
    },
    "tslib@2.0.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-uZtkfKblCEQtZKBF6EBXVZeQNl82yqtDQdv+eck8u7tdPxjLu2/lp5/uPW+um2tpuxINHWy3GhiccY7QgEaVHQ==",
        "name": "tslib",
        "url": "https://registry.npmjs.org/tslib/-/tslib-2.0.3.tgz",
    },
    "tslib@2.3.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-77EbyPPpMz+FRFRuAFlWMtmgUWGe9UOG2Z25NqCwiIjRhOf5iKGuzSe5P2w1laq+FkRy4p+PCuVkJSGkzTEKVw==",
        "name": "tslib",
        "url": "https://registry.npmjs.org/tslib/-/tslib-2.3.1.tgz",
    },
    "type-check@0.3.2": {
        "deps": [
            {
                "id": "prelude-ls@1.1.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-1BTv7+DrA/F0pQevb/CedTfW1my5T1ou73Y1LSTvPBY=",
        "name": "type-check",
        "url": "https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz",
    },
    "type-check@0.4.0": {
        "deps": [
            {
                "id": "prelude-ls@1.2.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-XleUoc9uwGXqjWwXaUTZAmzMcFZ5858QA2vvx1Ur5xIcixXIP+8LnFDgRplU30us6teqdlskFfu+ae4K79Ooew==",
        "name": "type-check",
        "url": "https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz",
    },
    "type-detect@4.0.8": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0fr/mIH1dlO+x7TlcMy+bIDqKPsw/70tVyeHW787goQjhmqaZe10uwLujubK9q9Lg6Fiho1KUKDYz0Z7k7g5/g==",
        "name": "type-detect",
        "url": "https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz",
    },
    "type-fest@0.20.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Ne+eE4r0/iWnpAxD852z3A+N0Bt5RN//NjJwRd2VFHEmrywxf5vsZlh4R6lixl6B+wz/8d+maTSAkN1FIkI3LQ==",
        "name": "type-fest",
        "url": "https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz",
    },
    "type-fest@0.21.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-t0rzBq87m3fVcduHDUFhKmyyX+9eo6WQjZvf51Ea/M0Q7+T374Jp1aUiyUl0GKxp8M/OETVHSDvmkyPgvX+X2w==",
        "name": "type-fest",
        "url": "https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz",
    },
    "typedarray-to-buffer@3.1.5": {
        "deps": [
            {
                "id": "is-typedarray@1.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-zdu8XMNEDepKKR+XYOXAVPtWui0ly0NtohUscw+UmaHiAWT8hrV1rr//H6V+0DvJ3OQ19S979M0laLfX8rm82Q==",
        "name": "typedarray-to-buffer",
        "url": "https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz",
    },
    "typescript@4.5.5": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-TCTIul70LyWe6IJWT8QSYeA54WQe8EjQFU4wY52Fasj5UKx88LNYKCgBEHcOMOrFF1rKGbD8v/xcNWVUq9SymA==",
        "name": "typescript",
        "url": "https://registry.npmjs.org/typescript/-/typescript-4.5.5.tgz",
    },
    "unique-filename@1.1.1": {
        "deps": [
            {
                "id": "unique-slug@2.0.2",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Vmp0jIp2ln35UTXuryvjzkjGdRyf9b2lTXuSYUiPmzRcl3FDtYqAwOnTJkAngD9SWhnoJzDbTKwaOrZ+STtxNQ==",
        "name": "unique-filename",
        "url": "https://registry.npmjs.org/unique-filename/-/unique-filename-1.1.1.tgz",
    },
    "unique-slug@2.0.2": {
        "deps": [
            {
                "id": "imurmurhash@0.1.4",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-zoWr9ObaxALD3DOPfjPSqxt4fnZiWblxHIgeWqW8x7UqDzEtHEQLzji2cuJYQFCU6KmoJikOYAZlrTHHebjx2w==",
        "name": "unique-slug",
        "url": "https://registry.npmjs.org/unique-slug/-/unique-slug-2.0.2.tgz",
    },
    "universalify@0.1.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-rBJeI5CXAlmy1pV+617WB9J63U6XcazHHF2f2dbJix4XzpUF0RS3Zbj0FGIOCAva5P/d/GBOYaACQ1w+0azUkg==",
        "name": "universalify",
        "url": "https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz",
    },
    "uri-js@4.4.1": {
        "deps": [
            {
                "id": "punycode@2.1.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==",
        "name": "uri-js",
        "url": "https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz",
    },
    "util-deprecate@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-eaHemDwbOTGAxHRW1rc8qrJ4oA6m431cZnXy3N7Co+U=",
        "name": "util-deprecate",
        "url": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
    },
    "uuid@8.3.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-+NYs2QeMWy+GWFOEm9xnn6HCDp0l7QBD7ml8zLUmJ+93Q5NF0NocErnwkTkXVFNiX3/fpC6afS8Dhb/gz7R7eg==",
        "name": "uuid",
        "url": "https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz",
    },
    "v8-compile-cache@2.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-l8lCEmLcLYZh4nbunNZvQCJc5pv7+RCwa8q/LdUx8u7lsWvPDKmpodJAJNwkAhJC//dFY48KuIEmjtd4RViDrA==",
        "name": "v8-compile-cache",
        "url": "https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz",
    },
    "v8-to-istanbul@8.1.1": {
        "deps": [
            {
                "id": "@types/istanbul-lib-coverage@2.0.4",
            },
            {
                "id": "convert-source-map@1.8.0",
            },
            {
                "id": "source-map@0.7.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-FGtKtv3xIpR6BYhvgH8MI/y78oT7d8Au3ww4QIxymrCtZEh5b8gCw2siywE+puhEmuWKDtmfrvF5UlB298ut3w==",
        "name": "v8-to-istanbul",
        "url": "https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-8.1.1.tgz",
    },
    "w3c-hr-time@1.0.2": {
        "deps": [
            {
                "id": "browser-process-hrtime@1.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-z8P5DvDNjKDoFIHK7q8r8lackT6l+jo/Ye3HOle7l9nICP9lf1Ci25fy9vHd0JOWewkIFzXIEig3TdKT7JQ5fQ==",
        "name": "w3c-hr-time",
        "url": "https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz",
    },
    "w3c-xmlserializer@2.0.0": {
        "deps": [
            {
                "id": "xml-name-validator@3.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-4tzD0mF8iSiMiNs30BiLO3EpfGLZUT2MSX/G+o7ZywDzliWQ3OPtTZ0PTC3B3ca1UAf4cJMHB+2Bf56EriJuRA==",
        "name": "w3c-xmlserializer",
        "url": "https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz",
    },
    "walker@1.0.8": {
        "deps": [
            {
                "id": "makeerror@1.0.12",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-ts/8E8l5b7kY0vlWLewOkDXMmPdLcVV4GmOQLyxuSswIJsweeFZtAsMF7k1Nszz+TYBQrlYRmzOnr398y1JemQ==",
        "name": "walker",
        "url": "https://registry.npmjs.org/walker/-/walker-1.0.8.tgz",
    },
    "watchpack@2.3.1": {
        "deps": [
            {
                "id": "glob-to-regexp@0.4.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-x0t0JuydIo8qCNctdDrn1OzH/qDzk2+rdCOC3YzumZ42fiMqmQ7T3xQurykYMhYfHaPHTp4ZxAx2NfUo1K6QaA==",
        "name": "watchpack",
        "url": "https://registry.npmjs.org/watchpack/-/watchpack-2.3.1.tgz",
    },
    "webidl-conversions@3.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-5N/DS0CUfCzwA4zZX6beIfTayTIkp62OFpIF9cLiLag=",
        "name": "webidl-conversions",
        "url": "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz",
    },
    "webidl-conversions@5.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-VlZwKPCkYKxQgeSbH5EyngOmRp7Ww7I9rQLERETtf5ofd9pGeswWiOtogpEO850jziPRarreGxn5QIiTqpb2wA==",
        "name": "webidl-conversions",
        "url": "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-5.0.0.tgz",
    },
    "webidl-conversions@6.1.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-qBIvFLGiBpLjfwmYAaHPXsn+ho5xZnGvyGvsarywGNc8VyQJUMHJ8OBKGGrPER0okBeMDaan4mNBlgBROxuI8w==",
        "name": "webidl-conversions",
        "url": "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-6.1.0.tgz",
    },
    "webpack-sources@3.2.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-/DyMEOrDgLKKIG0fmvtz+4dUX/3Ghozwgm6iPp8KRhvn+eQf9+Q7GWxVNMk3+uCPWfdXYC4ExGBckIXdFEfH1w==",
        "name": "webpack-sources",
        "url": "https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz",
    },
    "webpack@5.64.4": {
        "deps": [
            {
                "id": "@types/eslint-scope@3.7.3",
            },
            {
                "id": "@types/estree@0.0.50",
            },
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-edit@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-parser@1.11.1",
            },
            {
                "id": "acorn-import-assertions@1.8.0",
            },
            {
                "id": "acorn@8.7.0",
            },
            {
                "id": "browserslist@4.19.1",
            },
            {
                "id": "chrome-trace-event@1.0.3",
            },
            {
                "id": "enhanced-resolve@5.9.0",
            },
            {
                "id": "es-module-lexer@0.9.3",
            },
            {
                "id": "eslint-scope@5.1.1",
            },
            {
                "id": "events@3.3.0",
            },
            {
                "id": "glob-to-regexp@0.4.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "json-parse-better-errors@1.0.2",
            },
            {
                "id": "loader-runner@4.2.0",
            },
            {
                "id": "mime-types@2.1.34",
            },
            {
                "id": "neo-async@2.6.2",
            },
            {
                "id": "schema-utils@3.1.1",
            },
            {
                "id": "tapable@2.2.1",
            },
            {
                "id": "terser-webpack-plugin@5.3.1",
            },
            {
                "id": "watchpack@2.3.1",
            },
            {
                "id": "webpack-sources@3.2.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-LWhqfKjCLoYJLKJY8wk2C3h77i8VyHowG3qYNZiIqD6D0ZS40439S/KVuc/PY48jp2yQmy0mhMknq8cys4jFMw==",
        "name": "webpack",
        "url": "https://registry.npmjs.org/webpack/-/webpack-5.64.4.tgz",
    },
    "webpack@5.64.4-dc3fc578": {
        "deps": [
            {
                "id": "@types/eslint-scope@3.7.3",
            },
            {
                "id": "@types/estree@0.0.50",
            },
            {
                "id": "@webassemblyjs/ast@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-edit@1.11.1",
            },
            {
                "id": "@webassemblyjs/wasm-parser@1.11.1",
            },
            {
                "id": "acorn-import-assertions@1.8.0-e30e60ed",
            },
            {
                "id": "acorn@8.7.0",
            },
            {
                "id": "browserslist@4.19.1",
            },
            {
                "id": "chrome-trace-event@1.0.3",
            },
            {
                "id": "enhanced-resolve@5.9.0",
            },
            {
                "id": "es-module-lexer@0.9.3",
            },
            {
                "id": "eslint-scope@5.1.1",
            },
            {
                "id": "events@3.3.0",
            },
            {
                "id": "glob-to-regexp@0.4.1",
            },
            {
                "id": "graceful-fs@4.2.9",
            },
            {
                "id": "json-parse-better-errors@1.0.2",
            },
            {
                "id": "loader-runner@4.2.0",
            },
            {
                "id": "mime-types@2.1.34",
            },
            {
                "id": "neo-async@2.6.2",
            },
            {
                "id": "schema-utils@3.1.1",
            },
            {
                "id": "tapable@2.2.1",
            },
            {
                "id": "watchpack@2.3.1",
            },
            {
                "id": "webpack-sources@3.2.3",
            },
        ],
        "extra_deps": {
            "terser-webpack-plugin@5.3.1-e30e60ed": [
                {
                    "id": "webpack@5.64.4-dc3fc578",
                },
            ],
            "webpack@5.64.4-dc3fc578": [
                {
                    "id": "terser-webpack-plugin@5.3.1-e30e60ed",
                },
            ],
        },
        "integrity": "sha512-LWhqfKjCLoYJLKJY8wk2C3h77i8VyHowG3qYNZiIqD6D0ZS40439S/KVuc/PY48jp2yQmy0mhMknq8cys4jFMw==",
        "name": "webpack",
        "url": "https://registry.npmjs.org/webpack/-/webpack-5.64.4.tgz",
    },
    "whatwg-encoding@1.0.5": {
        "deps": [
            {
                "id": "iconv-lite@0.4.24",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-b5lim54JOPN9HtzvK9HFXvBma/rnfFeqsic0hSpjtDbVxR3dJKLc+KB4V6GgiGOvl7CY/KNh8rxSo9DKQrnUEw==",
        "name": "whatwg-encoding",
        "url": "https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz",
    },
    "whatwg-mimetype@2.3.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-M4yMwr6mAnQz76TbJm914+gPpB/nCwvZbJU28cUD6dR004SAxDLOOSUaB1JDRqLtaOV/vi0IC5lEAGFgrjGv/g==",
        "name": "whatwg-mimetype",
        "url": "https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz",
    },
    "whatwg-url@5.0.0": {
        "deps": [
            {
                "id": "tr46@0.0.3",
            },
            {
                "id": "webidl-conversions@3.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha256-sJ3EcfVzqHburDkCuMHaYq9c27yixvukoG8Rn4nLftM=",
        "name": "whatwg-url",
        "url": "https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz",
    },
    "whatwg-url@8.7.0": {
        "deps": [
            {
                "id": "lodash@4.17.21",
            },
            {
                "id": "tr46@2.1.0",
            },
            {
                "id": "webidl-conversions@6.1.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-gAojqb/m9Q8a5IV96E3fHJM70AzCkgt4uXYX2O7EmuyOnLrViCQlsEBmF9UQIu3/aeAIp2U17rtbpZWNntQqdg==",
        "name": "whatwg-url",
        "url": "https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.7.0.tgz",
    },
    "which@2.0.2": {
        "deps": [
            {
                "id": "isexe@2.0.0",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==",
        "name": "which",
        "url": "https://registry.npmjs.org/which/-/which-2.0.2.tgz",
    },
    "wide-align@1.1.5": {
        "deps": [
            {
                "id": "string-width@4.2.3",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-eDMORYaPNZ4sQIuuYPDHdQvf4gyCF9rEEV/yPxGfwPkRodwEgiMUUXTx/dex+Me0wxx53S+NgUHaP7y3MGlDmg==",
        "name": "wide-align",
        "url": "https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz",
    },
    "word-wrap@1.2.3": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-Hz/mrNwitNRh/HUAtM/VT/5VH+ygD6DV7mYKZAtHOrbs8U7lvPS6xf7EJKMF0uW1KJCl0H701g3ZGus+muE5vQ==",
        "name": "word-wrap",
        "url": "https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.3.tgz",
    },
    "wrap-ansi@7.0.0": {
        "deps": [
            {
                "id": "ansi-styles@4.3.0",
            },
            {
                "id": "string-width@4.2.3",
            },
            {
                "id": "strip-ansi@6.0.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-YVGIj2kamLSTxw6NsZjoBxfSwsn0ycdesmc4p+Q21c5zPuZ1pl+NfxVdxPtdHvmNVOQ6XSYG4AUtyt/Fi7D16Q==",
        "name": "wrap-ansi",
        "url": "https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz",
    },
    "wrappy@1.0.2": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-r/NzDZG3seFDgilW0UYI9WMWPPEbnQrmAt8f4eQw/fs=",
        "name": "wrappy",
        "url": "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz",
    },
    "write-file-atomic@3.0.3": {
        "deps": [
            {
                "id": "imurmurhash@0.1.4",
            },
            {
                "id": "is-typedarray@1.0.0",
            },
            {
                "id": "signal-exit@3.0.7",
            },
            {
                "id": "typedarray-to-buffer@3.1.5",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-AvHcyZ5JnSfq3ioSyjrBkH9yW4m7Ayk8/9My/DD9onKeu/94fwrMocemO2QAJFAlnnDN+ZDS+ZjAR5ua1/PV/Q==",
        "name": "write-file-atomic",
        "url": "https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz",
    },
    "ws@7.5.7": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KMvVuFzpKBuiIXW3E4u3mySRO2/mCHSyZDJQM5NQ9Q9KHWHWh0NHgfbRMLLrceUK5qAL4ytALJbpRMjixFZh8A==",
        "name": "ws",
        "url": "https://registry.npmjs.org/ws/-/ws-7.5.7.tgz",
    },
    "ws@7.5.7-f91bf4c0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-KMvVuFzpKBuiIXW3E4u3mySRO2/mCHSyZDJQM5NQ9Q9KHWHWh0NHgfbRMLLrceUK5qAL4ytALJbpRMjixFZh8A==",
        "name": "ws",
        "url": "https://registry.npmjs.org/ws/-/ws-7.5.7.tgz",
    },
    "xml-name-validator@3.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-A5CUptxDsvxKJEU3yO6DuWBSJz/qizqzJKOMIfUJHETbBw/sFaDxgd6fxm1ewUaM0jZ444Fc5vC5ROYurg/4Pw==",
        "name": "xml-name-validator",
        "url": "https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz",
    },
    "xml@1.0.1": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha256-OAMr1wH6IEJ7LuMe1V5nYc4aiBpuq82QAF6+dKsEpiM=",
        "name": "xml",
        "url": "https://registry.npmjs.org/xml/-/xml-1.0.1.tgz",
    },
    "xmlchars@2.2.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-JZnDKK8B0RCDw84FNdDAIpZK+JuJw+s7Lz8nksI7SIuU3UXJJslUthsi+uWBUYOwPFwW7W7PRLRfUKpxjtjFCw==",
        "name": "xmlchars",
        "url": "https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz",
    },
    "y18n@5.0.8": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-0pfFzegeDWJHJIAmTLRP2DwHjdF5s7jo9tuztdQxAhINCdvS+3nGINqPd00AphqJR/0LhANUS6/+7SCb98YOfA==",
        "name": "y18n",
        "url": "https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz",
    },
    "yallist@4.0.0": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==",
        "name": "yallist",
        "url": "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz",
    },
    "yargs-parser@20.2.9": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-y11nGElTIV+CT3Zv9t7VKl+Q3hTQoT9a1Qzezhhl6Rp21gJ/IVTW7Z3y9EWXhuUBC2Shnf+DX0antecpAwSP8w==",
        "name": "yargs-parser",
        "url": "https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz",
    },
    "yargs@16.2.0": {
        "deps": [
            {
                "id": "cliui@7.0.4",
            },
            {
                "id": "escalade@3.1.1",
            },
            {
                "id": "get-caller-file@2.0.5",
            },
            {
                "id": "require-directory@2.1.1",
            },
            {
                "id": "string-width@4.2.3",
            },
            {
                "id": "y18n@5.0.8",
            },
            {
                "id": "yargs-parser@20.2.9",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-D1mvvtDG0L5ft/jGWkLpG1+m0eQxOfaBvTNELraWj22wSVUMWxZUvYgJYcKh6jGGIkJFhH4IZPQhR4TKpc8mBw==",
        "name": "yargs",
        "url": "https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz",
    },
    "yarn@1.22.17": {
        "deps": [
        ],
        "extra_deps": {
        },
        "integrity": "sha512-H0p241BXaH0UN9IeH//RT82tl5PfNraVpSpEoW+ET7lmopNC61eZ+A+IDvU8FM6Go5vx162SncDL8J1ZjRBriQ==",
        "name": "yarn",
        "url": "https://registry.npmjs.org/yarn/-/yarn-1.22.17.tgz",
    },
    "zone.js@0.11.4": {
        "deps": [
            {
                "id": "tslib@2.3.1",
            },
        ],
        "extra_deps": {
        },
        "integrity": "sha512-DDh2Ab+A/B+9mJyajPjHFPWfYU1H+pdun4wnnk0OcQTNjem1XQSZ2CDW+rfZEUDjv5M19SBqAkjZi0x5wuB5Qw==",
        "name": "zone.js",
        "url": "https://registry.npmjs.org/zone.js/-/zone.js-0.11.4.tgz",
    },
}

ROOTS = [
    {
        "id": "@jest/types@27.4.2",
        "name": "@jest/types",
    },
    {
        "id": "@rollup/plugin-commonjs@16.0.0-dc3fc578",
        "name": "@rollup/plugin-commonjs",
    },
    {
        "id": "@rollup/plugin-node-resolve@13.0.4-dc3fc578",
        "name": "@rollup/plugin-node-resolve",
    },
    {
        "id": "@types/argparse@2.0.10",
        "name": "@types/argparse",
    },
    {
        "id": "@types/eslint@7.28.2",
        "name": "@types/eslint",
    },
    {
        "id": "@types/long@4.0.1",
        "name": "@types/long",
    },
    {
        "id": "@types/node-fetch@2.5.12",
        "name": "@types/node-fetch",
    },
    {
        "id": "@types/node@16.11.24",
        "name": "@types/node",
    },
    {
        "id": "@types/prettier@2.4.4",
        "name": "@types/prettier",
    },
    {
        "id": "@types/tar-stream@2.2.2",
        "name": "@types/tar-stream",
    },
    {
        "id": "@yarnpkg/cli-dist@3.1.1",
        "name": "@yarnpkg/cli-dist",
    },
    {
        "id": "argparse@2.0.1",
        "name": "argparse",
    },
    {
        "id": "enhanced-resolve@5.8.3",
        "name": "enhanced-resolve",
    },
    {
        "id": "eslint@8.3.0",
        "name": "eslint",
    },
    {
        "id": "jest-haste-map@27.4.6",
        "name": "jest-haste-map",
    },
    {
        "id": "jest-junit@13.0.0",
        "name": "jest-junit",
    },
    {
        "id": "jest@27.4.7-dc3fc578",
        "name": "jest",
    },
    {
        "id": "long@4.0.0",
        "name": "long",
    },
    {
        "id": "node-fetch@2.6.7-dc3fc578",
        "name": "node-fetch",
    },
    {
        "id": "protobufjs@6.11.2",
        "name": "protobufjs",
    },
    {
        "id": "rollup@2.58.3",
        "name": "rollup",
    },
    {
        "id": "tar-stream@2.2.0",
        "name": "tar-stream",
    },
    {
        "id": "ts-proto@1.83.3",
        "name": "ts-proto",
    },
    {
        "id": "tslib@2.0.3",
        "name": "tslib",
    },
    {
        "id": "typescript@4.5.5",
        "name": "typescript",
    },
    {
        "id": "webpack@5.64.4-dc3fc578",
        "name": "webpack",
    },
    {
        "id": "yarn@1.22.17",
        "name": "yarn",
    },
    {
        "id": "zone.js@0.11.4",
        "name": "zone.js",
    },
]
