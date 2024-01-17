import { getCategories } from "@services/get-categories";
import { getWallpapers } from "@services/get-wallpapers";

export async function getAllWallpapers() {
	const categories = await getCategories();

	const allWallpapers = categories?.map(async (name) => {
		const wallaperByCategory = await getWallpapers({ category: name });
		return wallaperByCategory;
	});

	if (allWallpapers) {
		return await Promise.allSettled(allWallpapers);
	}
}
