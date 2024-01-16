import type { APIRoute } from "astro";
import { getWallpapers } from "../../../../services/external/get-wallpapers";
import { generateGithubWallpaperEndpoint } from "../../../../services/config/external";

export const GET: APIRoute = async ({ request, params }) => {
	const { category } = params;

	if (!category) return new Response(JSON.stringify([]));

	const wallpapers = await getWallpapers({
		apiUrl: generateGithubWallpaperEndpoint(category),
	});

	return new Response(
		JSON.stringify({
			category,
			wallpapers,
			total_results: wallpapers.length,
		}),
	);
};
