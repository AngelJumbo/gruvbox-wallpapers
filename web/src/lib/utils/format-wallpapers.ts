import type { GithubResponseType } from "src/types";

export function formatWallpapers(data: GithubResponseType[]) {
	return data.map(({ name, download_url }) => ({
		name,
		download_url,
	}));
}
