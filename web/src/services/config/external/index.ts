export const API_URL_WALLPAPERS_CATEGORIES =
	"https://api.github.com/repos/AngelJumbo/gruvbox-wallpapers/contents/wallpapers";

export const GITHUB_TOKEN = import.meta.env.GITHUB_TOKEN;

export const generateGithubWallpaperEndpoint = (category: string) =>
	`https://api.github.com/repos/AngelJumbo/gruvbox-wallpapers/contents/wallpapers/${category}?per_page=5`;

export const config = {
	method: "GET",
	headers: {
		"Content-Type": "application/json",
		Authorization: `Bearer ${GITHUB_TOKEN}`,
	},
};
