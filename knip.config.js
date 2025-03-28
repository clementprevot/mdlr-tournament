const config = () => {
	const defaultConfig = {
		entry: [
			'{index,main,cli}.{js,cjs,mjs,jsx,ts,cts,mts,tsx}!',
			'src/{index,main,cli}.{js,cjs,mjs,jsx,ts,cts,mts,tsx}!',
			'tailwind.config.{js,cjs,mjs,ts,cts,mts}!',
			'src/i18n.{js,cjs,mjs,ts,cts,mts}!',
		],
		ignore: [
			'database.ts',
			'schemas.ts',
			'schemas.d.ts',
			'postcss.config.{js,cjs,mjs}',
		],
		project: ['**/*.{js,cjs,mjs,jsx,ts,cts,mts,tsx}!'],
	}

	return {
		ignoreDependencies: ['prettier', 'sharp'],
		ignoreExportsUsedInFile: {
			class: false,
			enum: false,
			function: false,
			interface: true,
			member: false,
			type: true,
		},
		includeEntryExports: true,
		workspaces: {
			'.': {
				...defaultConfig,
				entry: [...defaultConfig.entry],
			},
		},
	}
}

export default config
