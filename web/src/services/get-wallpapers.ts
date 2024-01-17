import { FETCH_CONFIG, generateWallpapersApiUrl } from "@services/config/index";
import { formatWallpapers } from "@lib/utils/format-wallpapers";
import type { Gallery, GithubResponseType } from "src/types";

export async function getWallpapers({
	category,
}: { category: string }): Promise<Gallery | null[]> {
	try {
		const apiUrl = generateWallpapersApiUrl(category);
		const res = await fetch(apiUrl, FETCH_CONFIG);
		const json = (await res.json()) as GithubResponseType[];

		const wallpapers = formatWallpapers(json);

		return {
			wallpapers,
			category,
			total_results: wallpapers.length,
		};
	} catch (error) {
		return [];
	}
}
