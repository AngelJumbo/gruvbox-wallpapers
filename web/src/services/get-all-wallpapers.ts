import { getCategories } from "@services/get-categories";
import { getWallpapers } from "@services/get-wallpapers";
import { IMAGES_FOR_PREVIEW } from "@lib/constants/index";

export async function getAllWallpapers() {
	const categories = await getCategories();

	const allWallpapers = categories?.map(async (name) => {
		const wallaperByCategory = await getWallpapers({
			category: name,
			limit: IMAGES_FOR_PREVIEW,
		});
		return wallaperByCategory;
	});

	if (allWallpapers) {
		return await Promise.allSettled(allWallpapers);
	}
}
