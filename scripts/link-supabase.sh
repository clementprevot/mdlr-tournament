#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

bold_info "Linking Supabase project"

if [ -z "$SUPABASE_PROJECT_ID" ] || [ -z "$POSTGRES_PASSWORD" ]; then
	ENV_FILE_PATH=".env.local"
	echo -en "\tSetting up environment from $(display_path "$ENV_FILE_PATH")... "

	if [ -r "$ENV_FILE_PATH" ]; then
		set -o allexport

		# shellcheck disable=SC1090
		source "$ENV_FILE_PATH"

		set +o allexport

		success "Done"
	else
		bold_error "No .env.local file found."
		warning "Have you linked your Vercel project (\`pnpm run link-vercel\`) and updated env var (\`pnpm run update-env\`)?"
	fi
fi

if [ -z "$SUPABASE_PROJECT_ID" ]; then
	bold_error "You must provide the 'SUPABASE_PROJECT_ID' environment variable!"
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
	bold_error "You must provide the 'POSTGRES_PASSWORD' environment variable!"
fi

if [ -z "$SUPABASE_PROJECT_ID" ] || [ -z "$POSTGRES_PASSWORD" ]; then
	exit 1
fi

echo -en "\tLinking with project in Supabase (using Supabase CLI)... "

export SUPABASE_DB_PASSWORD="$POSTGRES_PASSWORD"
if ! pnpm supabase link --project-ref "$SUPABASE_PROJECT_ID"; then
	bold_error "Failed to link Supabase project $(display_branch "$SUPABASE_PROJECT_ID")!"

	cd - &>/dev/null || exit

	exit 1
fi

cd - &>/dev/null || exit

success "Done"

bold_success "Supabase project $(display_branch "$SUPABASE_PROJECT_ID") has been linked!"
