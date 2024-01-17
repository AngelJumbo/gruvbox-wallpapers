import type { GithubResponseType } from "src/types";

export function formatCategories(data: GithubResponseType[]) {
	return data.map(({ name }) => name);
}
