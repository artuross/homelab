_list:
    @just --list

format:
    yamlfmt -continue_on_error **/*.yaml

generate-k8s-manifests:
    kubesource
    just format

generate-schemas:
    rip ./schemas
    mkdir ./schemas
    talhelper genschema --file ./schemas/talconfig.json

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
