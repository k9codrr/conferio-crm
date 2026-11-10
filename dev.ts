import { existsSync } from "node:fs";

const extra = process.argv.slice(2);
const cmd =
	process.platform === "win32" && existsSync(`${import.meta.dir}/dev.ps1`)
		? ["powershell", "-ExecutionPolicy", "Bypass", "-File", `${import.meta.dir}/dev.ps1`, ...extra]
		: ["bunx", "turbo", "run", "dev", ...extra];

const proc = Bun.spawn(cmd, { stdio: ["inherit", "inherit", "inherit"], cwd: import.meta.dir });
process.exit(await proc.exited);
