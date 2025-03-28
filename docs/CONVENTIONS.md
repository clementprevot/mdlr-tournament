# Conventions

## Code style

Code style is enforced using
[OXLint](https://oxc.rs/docs/guide/usage/linter.html) from the
[OXC project](https://oxc.rs/).

See the [dedicated `TOOLING.md` documentation](./TOOLING.md) for more
information.

### Special notes on code style

#### On quotes

We are using single quotes (`'`) in the codebase. OXLint should take care of
this for you.

When you need to have single quotes inside of a string, you should use double
quotes (`"`)

Also note that
**you are not allowed to use backticks (`` ` ``) when the String Template doesn't hold any variable interpolations (`${myVar}`)**.

Don't worry though. If you mis-used a quote, the linter will warn you, will
auto-fix it for you on save and will auto-format everything for you too.

## Typing

**Always prefer using TypeScript over JavaScript.**

This repository offers you all the toolings you need to use TypeScript in your
application or package, so please use it to enforce type checking and make your
code more reliable and self-documented.

Of course, you can configure/disable/extend the base TypeScript configuration
_(using the [`tsconfig.json`](../tsconfig.json) file at root)_

### Special notes on typing

#### On Booleans

To make the code easily redable and self-documentation, we need to ensure to use
the proper conventions and right types as much as possible.

For examples, on a code like this:

```js
if (isReady) {
	// Do something.
}
```

We definitely expect `isReady` to be `Boolean`. Of course, in JS it could be
anything, but it is misleading for everyone. So here are the rules:

- A variable name starting with `has` or `is` has to be a Boolean
- The output of a condition (`if`, `while`, ...) has to be a Boolean

A good practice is to use methods offered by Lodash to ensure some conditions.

❌

```js
if (someArray.length > 0) {
	// Do something
}
if (someNumber) {
	// Do something
}
if (someString) {
	// Do something
}

// Careful, this is true!
const emptyObject = {}
if (emptyObject) {
	// Do something
}
```

✅

```js
import isEmpty from 'lodash/fp/isEmpty'

if (!isEmpty(someArray)) {
	// Do something
}
if (someNumber > 0) {
	// Do something
}
if (!isEmpty(someString)) {
	// Do something
}
if (!isEmpty(emptyObject)) {
	// Do something
}
```

#### What's defined is not undefined

When resetting a value or putting a default value to something, always try to
use `null` instead of `undefined`.  
It does not make sense to specify an undefined value to a variable, right?

- `null`: has been declared & defined. Has simply no value.
- `undefined`: declared but not defined.

⚠️ When defining default parameters, `undefined` will use the default while
`null` does not.

Also, extensively use the optional chaining operator `?.` to avoid `undefined`
and the nullish coalescing operator `??` to avoid `null`.

### `FIXME`s and `TODO`s

We always want to keep track on what remains to do on the code base.

If you want to finish something later or clean part of the code, you just have
to add a `TODO` associated with a ticket number and a small description as done
in the example. If you want to highlight a potential code smell that needs to be
fixed ASAP, you just have to add a `FIXME` associated with a ticket number and a
small description as done in the example.

```js
/*
 * TODO [#1234]
 * Define a proper error state in case of failure inside
 */
```

## Components guidelines

### Self-responsibility

For a component-based architecture to be efficient, a component must have a
clear responsibility.

It should be only responsible for its own logic, style and templating.

### Readability

Readability makes a component easy to understand, to review and to re-use for
everyone.  
This will also greatly improve the self-documentation of your code.

Here are a few rules to ease the readability:

- If you have a big block of logic in a JSX block, try to extract it into a
  function and call it instead;
- If you have a static value to use in your component, add it as a constant so
  it's more explicit, adds context for the reviewers and is harder to remove it
  accidentally.
  You can also extract those constants in dedicated `constants.ts` files;
- The same applies for your TypeScript typings. Always create a dedicated type
  instead of inlining it in the code.
  If those types are used in multiple components, you can extract them in
  dedicated `types.ts` files;

### Avoid duplication

If a condition/computation is repeated more than once in your component, create
a function. This way, refactoring of the condition/computation will be easier.
