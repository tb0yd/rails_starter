let env = process.argv[2]

const esbuild = require("esbuild")
const path = require("path")

esbuild.build({
    entryPoints: ["app/assets/javascripts/application.js"],
    bundle: true,
    outdir: path.join(process.cwd(), "public/builds"),
    absWorkingDir: process.cwd(),
    sourcemap: env !== "production",
    minify: env === "production",
    target: ["es2015"],
    plugins: [],
}).catch((err) => {
    console.error(err);
    process.exit(1)
})

