import type { Category } from "../../types";
import { CATEGORIES_API_URL } from "../config/internal";

export async function getCategories() {
	try {
		const res = await fetch(CATEGORIES_API_URL);
		const json = (await res.json()) as Category[];

		return json;
	} catch (error) {}
}
