export const GITHUB_TOKEN = import.meta.env.GITHUB_TOKEN;

export const CATEGORIES_API_URL =
	"https://api.github.com/repos/ChapST1/gruvbox-wallpapers/contents/wallpapers";

export function generateWallpapersApiUrl(category: string) {
	return `https://api.github.com/repos/ChapST1/gruvbox-wallpapers/contents/wallpapers/${category}`;
}

export const FETCH_CONFIG = {
	method: "GET",
	headers: {
		"Content-Type": "application/json",
		Authorization: `Bearer ${GITHUB_TOKEN}`,
	},
};
