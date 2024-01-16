/* 
	External
*/

/**
 * Github API -  CATEGORIES
 */

export interface GithubResponseType {
	name: string;
	path: string;
	sha: string;
	size: number;
	url: string;
	html_url: string;
	git_url: string;
	download_url: null | string;
	type: string;
	_links: Links;
}

export interface Links {
	self: string;
	git: string;
	html: string;
}

/* 
	Internal
*/

export interface Category {
	name: GithubResponseType["name"];
	self: GithubResponseType["_links"]["self"];
}

export interface Wallpaper {
	name: GithubResponseType["name"];
	download_url: GithubResponseType["download_url"];
}

export interface Gallery {
	category: string;
	wallpapers: Wallpaper[];
	total_results: number | string;
}
