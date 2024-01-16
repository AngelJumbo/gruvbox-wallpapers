import { getCategories } from "./get-categories";
import { getWallpapers } from "./get-wallpapers";

export async function getAllWallpapers() {
	const categories = await getCategories();

	const allWallpapers = categories?.map(async ({ name }) => {
		const wallaperByCategory = await getWallpapers({ name });
		return wallaperByCategory;
	});

	if (allWallpapers) {
		return await Promise.allSettled(allWallpapers);
	}
}
