/**
 * @type {import('lint-staged').Configuration}
 */
export default {
	'*.{js,mjs,cjs,jsx,ts,mts,cts,tsx,json,json5,jsonc,htm,html,xhtml,html5,yml,yaml}':
		['oxlint --fix', 'prettier --ignore-unknown --cache --write'],
}
