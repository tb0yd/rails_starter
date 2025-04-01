const esbuild = require("esbuild")
const path = require("path")
const glob = require("glob")

// Find all JavaScript files in app/javascript
const entryPoints = glob.sync("app/assets/javascripts/**/*.js")

// Build options
esbuild
  .build({
    entryPoints,
    bundle: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: process.cwd(),
    sourcemap: process.env.NODE_ENV !== "production",
    minify: process.env.NODE_ENV === "production",
    splitting: false,
    format: "esm",
    target: ["es2020"],
    plugins: [],
  })
  .catch(() => process.exit(1))

