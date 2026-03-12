# Local development with live reload
dev:
    docker compose up dev

# Build and serve production image (nginx)
serve:
    docker compose up --build prod

# Build the static site locally (requires hugo)
build:
    hugo

# Build and check all links
test: clean
    docker run --rm -v .:/src hugomods/hugo:latest hugo
    docker run --rm -v ./public:/public -v ./.htmltest.yml:/.htmltest.yml wjdp/htmltest --conf /.htmltest.yml --skip-external /public

# Clean generated output
clean:
    docker run --rm -v .:/src hugomods/hugo:latest rm -rf /src/public
