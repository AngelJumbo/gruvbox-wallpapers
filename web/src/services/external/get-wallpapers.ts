import type { GithubResponseType } from "../../types";
import { config } from "../config/external";

export async function getWallpapers({ apiUrl }: { apiUrl: string }) {
	try {
		const res = await fetch(apiUrl, config);
		const json = (await res.json()) as GithubResponseType[];
		const mappedData = json.map(({ name, download_url }) => ({
			name,
			download_url,
		}));

		return mappedData;
	} catch (error) {
		return [];
	}
}
