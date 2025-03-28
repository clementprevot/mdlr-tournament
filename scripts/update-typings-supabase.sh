#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

SCHEMAS="${2:-public}"

SUPABASE_TYPES_FILE="database.ts"
ZOD_SCHEMA_FILE="schema.ts"
ZOD_SCHEMA_TYPES_FILE="schema.d.ts"

bold_info "Updating Supabase typings"

if [ -z "$SUPABASE_PROJECT_ID" ]; then
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

	exit 1
fi

echo -en "\tLoading typings from Supabase (using Supabase CLI)... "

export SUPABASE_DB_PASSWORD="$POSTGRES_PASSWORD"
if ! pnpm supabase gen types typescript --project-id "$SUPABASE_PROJECT_ID" -s "$SCHEMAS" >"$SUPABASE_TYPES_FILE"; then
	bold_error "Failed to update typings for Supabase project $(display_branch "$SUPABASE_PROJECT_ID")!"

	rm -Rf "supabase/.temp"
	rm -Rf "supabase/supabase"

	exit 1
fi

rm -Rf "supabase/.temp"
rm -Rf "supabase/supabase"

if ! pnpm supazod -i "$SUPABASE_TYPES_FILE" -o "$ZOD_SCHEMA_FILE" -t "$ZOD_SCHEMA_TYPES_FILE" -s "$SCHEMAS" &>/dev/null; then
	bold_error "Failed to create Zod schemas for Supabase project $(display_branch "$SUPABASE_PROJECT_ID")!"

	exit 1
fi

success "Done"

echo -en "\tLinting and formatting the file... "

if ! pnpm oxlint --fix "$SUPABASE_TYPES_FILE" "$ZOD_SCHEMA_FILE" "$ZOD_SCHEMA_TYPES_FILE" >/dev/null 2>&1 && pnpm prettier --cache --write "$SUPABASE_TYPES_FILE" "$ZOD_SCHEMA_FILE" "$ZOD_SCHEMA_TYPES_FILE" >/dev/null 2>&1; then
	warning "An error occurred while linting and formatting the types and schemas files!"
else
	success "Done"
fi

bold_success "Supabase typings for $(display_branch "$SUPABASE_PROJECT_ID") has been updated!"
