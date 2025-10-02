_list:
    @just --list

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
