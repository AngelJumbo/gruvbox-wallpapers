import type { Gallery } from "../../types";
import { generateApiUrlByName } from "../config/internal";

export async function getWallpapers({ name }: { name: string }) {
	try {
		const url = generateApiUrlByName({ name });
		const res = await fetch(url);
		const json = (await res.json()) as Gallery;

		return json;
	} catch (error) {}
}
