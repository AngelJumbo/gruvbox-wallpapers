import { FETCH_CONFIG, generateWallpapersApiUrl } from "@services/config/index";
import { formatWallpapers } from "@lib/utils/format-wallpapers";
import type { Gallery, GithubResponseType } from "src/types";

export async function getWallpapers({
	category,
	limit,
}: { category: string; limit?: number }): Promise<Gallery | null[]> {
	if (!category) return [];
	try {
		const apiUrl = generateWallpapersApiUrl(category);
		const res = await fetch(apiUrl, FETCH_CONFIG);
		const json = (await res.json()) as GithubResponseType[];
		const wallpapers = formatWallpapers(json);

		if (limit) {
			const limitWallpapers = wallpapers.slice(0, limit);
			return {
				wallpapers: limitWallpapers,
				category,
				total_results: json.length,
			};
		}

		return {
			wallpapers,
			category,
			total_results: json.length,
		};
	} catch (error) {
		return [];
	}
}
