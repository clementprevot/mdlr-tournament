import type { NextConfig } from 'next'
const debugMode =
    (process.env.DEBUG ||
        process.env.NEXT_PUBLIC_DEBUG ||
        process.env.DEBUG_NEXT_CONFIG) === 'true'

const nextConfig: NextConfig = {
    eslint: {
        // We disable Next.JS integrated ESLint because we use OXLint.
        ignoreDuringBuilds: true,
    },

    experimental: {
        optimizePackageImports: ['@react-hookz/web', 'lodash'],
        serverSourceMaps: true,
    },

    images: {
        remotePatterns: [
            {
                hostname: '**',
                protocol: 'https',
            },
            {
                hostname: '**.localhost',
                protocol: 'http',
            },
        ],
    },

    productionBrowserSourceMaps: true,
    reactStrictMode: true,
}

let actualConfig = nextConfig

if (debugMode) {
    console.debug({
        config: {
            ...actualConfig,
            debug: debugMode,
        },
    })
}

export default actualConfig
