# Liquid Glass Calculator

Fancy liquid-glass calculator built with ElementaryUI, Swift, and WebAssembly.

## Requirements

- Swift.org Swift 6.3.2 toolchain on `PATH`
- Swift WebAssembly SDK `swift-6.3.2-RELEASE_wasm`
- Node.js 22+

On this machine:

```sh
. /Users/roman/.swiftly/env.sh
swift sdk list
```

## Run

```sh
npm install
npm run dev
```

## Build

```sh
npm run build
```

The production build uses the local `binaryen` package for `wasm-opt`.
Keep the Swiftly environment active so the Vite plugin can detect the matching
Swift WebAssembly SDK automatically.
