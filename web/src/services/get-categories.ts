import { formatCategories } from "@lib/utils/format-categories";
import { CATEGORIES_API_URL, FETCH_CONFIG } from "@services/config/index";
import type { GithubResponseType } from "src/types";

export async function getCategories() {
	try {
		const res = await fetch(CATEGORIES_API_URL, FETCH_CONFIG);
		const json = (await res.json()) as GithubResponseType[];
		const categories = formatCategories(json);

		return categories;
	} catch (error) {}
}
