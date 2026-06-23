import { defineConfig } from "vite";
import swiftWasm from "@elementary-swift/vite-plugin-swift-wasm";

export default defineConfig({
  base: process.env.GITHUB_PAGES === "true" ? "/hello-world-swift/" : "/",
  plugins: [swiftWasm()],
});
