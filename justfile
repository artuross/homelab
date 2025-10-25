set shell := ["nu", "-c"]

_list:
    @just --list

format:
    fd . --extension=yaml \
        | lines \
        | par-each --threads 32 { |file| yamlfmt $file } \
        | where (is-not-empty) \
        | to text

[group("generate")]
generate-k8s-manifests:
    kubesource
    just format

[group("generate")]
generate-schemas:
    rip ./schemas
    mkdir ./schemas
    talhelper genschema --file ./schemas/talconfig.json

[group("generate")]
generate-talos-config:
    op run \
        --env-file .env \
        --no-masking \
        -- \
        talhelper genconfig \
            --config-file talos/talconfig.yaml \
            --no-gitignore \
            --out-dir talos/.rendered \
            --secret-file talos/talsecret.yaml
