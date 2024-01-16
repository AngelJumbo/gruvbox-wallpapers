import type { APIRoute } from "astro";
import { getCategories } from "../../../services/external/get-categories";

export const GET: APIRoute = async () => {
	const categories = await getCategories({});

	return new Response(JSON.stringify(categories));
};
