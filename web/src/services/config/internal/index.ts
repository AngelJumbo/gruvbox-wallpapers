export const CATEGORIES_API_URL =
	"http://localhost:4321/api/wallpapers/categories";

export const API_URL = "http://localhost:4321/api/wallpapers";

export function generateApiUrlByName({
	name,
	limit,
}: { name: string; limit?: number }) {
	return `${API_URL}/${name}`;
}
