# Local development with live reload
dev:
    docker compose up dev

# Build and serve production image (nginx)
serve:
    docker compose up --build prod

# Build the static site locally (requires hugo)
build:
    hugo

# Clean generated output
clean:
    rm -rf public
