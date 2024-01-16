import type { GithubResponseType } from "../../types";
import {
	API_URL_WALLPAPERS_CATEGORIES,
	GITHUB_TOKEN,
	config,
} from "../config/external";

interface GetCategoriesProps {
	byName?: string;
}

export async function getCategories({ byName }: GetCategoriesProps) {
	try {
		const res = await fetch(API_URL_WALLPAPERS_CATEGORIES, config);

		const json = (await res.json()) as GithubResponseType[];

		const mappedCategories = json.map(({ name, _links: { self } }) => ({
			name,
			self,
		}));

		if (byName) {
			const find = mappedCategories.find((item) => item.name === byName);
			return find;
		}

		return mappedCategories;
	} catch (error) {}
}
