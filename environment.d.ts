declare global {
	namespace NodeJS {
		interface ProcessEnv {
			ENVIRONMENT: 'preproduction' | 'production'
			NEXT_PUBLIC_LOG_LEVEL: 'debug' | 'error' | 'info' | 'warning'
			NEXT_PUBLIC_SUPABASE_ANON_KEY: string
			NEXT_PUBLIC_SUPABASE_URL: string
			POSTGRES_URL: string
			POSTGRES_URL_NON_POOLING: string
			SUPABASE_ANON_KEY: string
			SUPABASE_API_KEY: string
			SUPABASE_URL: string
			VERCEL_ENV: 'development' | 'preview' | 'production'
			VERCEL_GIT_COMMIT_SHA: string
			VERCEL?: '1'
		}
	}
}

// If this file has no import/export statements (i.e. is a script)
// convert it into a module by adding an empty export statement.
export {}
