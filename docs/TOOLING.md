# Tooling

## Package management

This repository uses [PNPM](https://pnpm.io/) to manage packages and scripts.

## Vercel

> To be able to do anything in Vercel, you'll have to make sure to have the
> proper permissions on the Vercel project. If it's not the case, please reach
> out to someone that can help you with that.

If you want to deploy your application to Vercel, you will have to link your
local folder with a Vercel project.

To do so, go in your directory and run:

```bash
vercel link
```

or (if it's not globally available):

```bash
pnpm run vercel link
```

Then follow the instructions to link your local directory to your Vercel
project.

Vercel is a great choice to deploy your application because it handles so much
directly on it's own _(e.g. automatic deployment on commit)_. If you develop
your application with the Next.JS framework, the integration is even greater and
you can enjoy Analytics, Speed insight or direct Database integration in a
breeze.

### Environment variables

Environment variables are handled using `.env` files. You can use multiple
variations of `.env` files like `.env.local`
_(which should never be committed in the repository because it contains secrets)_
, `.env.development` for environment variable dedicated to the development
server
_(and that are not secret so can be shared with other developers by committing it in the repository)_
or even `.env.production` to define environment variables dedicated to be used
in production.

If you are using Vercel _(and if you have linked you project)_, all environment
variables can be directly handled via the Vercel interface at the project level
_(e.g. <https://vercel.com/__team__/__project__/settings/environment-variables>)_
where you can define project specific environment variable or link global ones.  
Then when you have defined your environment variables for your project, you can
simply run

```bash
pnpm run vercel env pull
```

This will generate all the appropriate `.env` files for you.

## Dependencies

Dependencies are kept up to date using [Renovate](https://renovatebot.com/).
Of course, you can configure/disable/extend the configuration
_(using the [`renovate.json5`](../renovate.json5) file at the root)_.

Renovate is a _(better)_ alternative to Dependabot. It brings a lot of new
features and improvements to dependency management such as:

- Renovate handles
  [WAY more ecosystems](https://docs.renovatebot.com/modules/manager/#supported-manager)
  than Dependabot
- It supports regexes to be able to be able to parse any string as a dependency
  version and indicate to Renovate where to look for newer versions (look
  [here](https://github.com/mkniewallner/showcase-renovate/blob/a4b294272099536a67aa8fe5122715743262ce80/.github/workflows/ci.yml#L24)
  for instance)
- It supports WAY more options and extensible rules (schedules, auto-merges,
  custom labels, … seriously,
  [look at all those options](https://docs.renovatebot.com/configuration-options/)!)
- Is supports
  [reusable configurations](https://docs.renovatebot.com/config-presets/),
  so you can store a common configuration in a repository (or several if you
  want), and can re-use it across multiple repositories (to avoid duplication
  and ensure that everybody has the same base config)
- And a lot more :smile:

This tools helps us keep our dependencies up to date and avoid security issues
by automatically generating Pull Requests to update the dependencies. It even
auto-merge patches update to speed up the process.

<details>
  <summary>Discussions about some dependencies</summary>

This chapter serves as an annotation to `package.json` and the dependencies of
the project.

The goal is not to explain the ins and outs of every dependency, but rather to
serve as useful history and background to some of the choices made — and why we
have some of the dependencies in the project.

<details>
  <summary>Lodash</summary>

Using `lodash-es` had a severe performance penalty on the Jest tests, since
`lodash-es` uses an index.js file which contains references to all of the
operators this had to be compiled for every test file. There is also the initial
performance penalty of having to transform from ESM to CJS.

The performance of `lodash-es` is significantly worse, and only becomes worse as
more tests are run.

Also, `lodash-es` is not tree-shakeable, so it will always be included in the
final bundle.

That's why the preferred way of using Lodash is by importing functions through
their dedicated export file, e.g.:

```js
import isEmpty from 'lodash/fp/isEmpty'
```

> Note that if you are using TypeScript and want to enjoying typeguards in some
> Lodash functions (like `isEmpty` or `isString`) you should consider importing
> it from the `fp` submodule as demonstrated above.

</details>
</details>

## Convention enforcement

Conventions at enforced at the repository level using
[OXLint](https://oxc.rs/docs/guide/usage/linter.html) from the
[OXC project](https://oxc.rs/).

You can configure the linting and formatting rules using the
[`.oxlintrc.json` file](../.oxlintrc.json) (see the
[documentation](https://oxc.rs/docs/guide/usage/linter/config.html) to learn
more about configuring OXLint).

We also have those conventions enforced:

1. as a pre-commit hook (using [Husky](https://typicode.github.io/husky/) and
   [lint-staged](https://github.com/lint-staged/lint-staged), that check the
   format, errors and warning before committing the code (see
   [`.husky/pre-commit`](../.husky/pre-commit) and
   [`.lintstagedrc.js`](../.lintstagedrc.js)),
2. during Continuous Integration, by running non-changing linting steps
   (`pnpm run lint` and `pnpm run format`).

> **Note:** while these steps ensure our codebase follows our coding standards,
> it is recommended to enable automatic fixing in your IDE, to reduce friction
> during commit.

## VSCode/Cursor

### Plugins

The [`.vscode/extensions.json`](../.vscode/extensions.json) file contains a list
of recommended plugins for you to use. When you'll load the repository for the
first time in VSCode, your IDE will offer you to install the one you don't have.

#### OXLint

1. Install
   [OXC extension](https://marketplace.visualstudio.com/items?itemName=oxc.oxc-vscode).
2. Enable auto-fix on save by adding the following to
   `Editor: Code Actions on Save` in your workspace settings:

```json
{
	"editor.codeActionsOnSave": {
		"source.fixAll.oxc": true
	}
}
```

3. Test: edit a `.md`, `.js`, `.tsx` or any other supported file (ex: jump
   multiple lines), and save your file.

### Settings

There is also a [`.vscode/settings.json`](../.vscode/settings.json) that is used
to share the recommended setting for VSCode.

Please be carefull to not add anything specific to your personal use case in
this file.

#### Recommended Visual Studio Code settings

```json
{
	"css.validate": false,
	"editor.codeActionsOnSave": [
		"source.organizeLinkDefinitions",
		"source.addMissingImports.ts",
		"source.removeUnusedImports",
		"source.fixAll.oxc",
		"source.fixAll.markdownlint",
		"source.fixAll.shellcheck",
		"source.fixAll.ts",
		"source.fixAll.sortJSON",
		"source.formatDocument"
	],
	"editor.defaultFormatter": "oxc.oxc-vscode",
	"editor.formatOnPaste": true,
	"editor.formatOnSave": false,
	"editor.formatOnType": true,
	"editor.insertSpaces": false,
	"editor.quickSuggestions": {
		"comments": false,
		"other": true,
		"strings": true
	},
	"editor.tabSize": 4,
	"files.insertFinalNewline": true,
	"files.trimFinalNewlines": true,
	"files.trimTrailingWhitespace": true,
	"javascript.format.enable": false,
	"javascript.validate.enable": false,
	"less.validate": false,
	"oxc.enable": true,
	"scss.validate": false,
	"tailwindCSS.experimental.classRegex": [
		[
			"(?:\\b(?:const|let|var)\\s+)?[\\w$_]*(?:[Ss]tyles?|[Cc]lasses?|[Cc]lass[nN]ames?)[\\w\\d]*\\s*(?:=|\\+=)\\s*['\"]([^'\"]*)['\"]"
		],
		[
			"(?:[Ss]tyles?|[Cc]lasses?|[Cc]lass[nN]ames?)\\s*(?::\\s*[^=]+)?\\s*=\\s*([^;]*);",
			"['\"`]([^'\"`]*)['\"`]"
		],
		[
			"classList.(?:add|remove)\\(([^)]*)\\)",
			"(?:'|\"|`)([^\"'`]*)(?:'|\"|`)"
		],
		[
			"(?:twMerge|twJoin|cn|cj|classnames)\\(([^)]*)\\)",
			"[\"'`]([^\"'`]*)[\"'`]"
		],
		["clsx\\(.*?\\)(?!\\])", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)"],
		"return '(.*)'",
		["return \\(?{([\\s\\S]+?)}\\(?\\s", "'([^']*)'"]
	],
	"tailwindCSS.rootFontSize": 8,
	"typescript.format.enable": false,
	"typescript.preferences.quoteStyle": "single",
	"typescript.tsdk": "./node_modules/typescript/lib"
}
```
