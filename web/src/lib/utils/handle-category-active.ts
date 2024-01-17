export function handleCategoryActive(pagePath: string, value: string) {
	return pagePath.toLocaleLowerCase() === value.toLocaleLowerCase()
		? "bg-[#282828] text-[#e7dba8]"
		: "bg-[transparent] text-[text-[#282828]] hover:text-[#e7dba8]";
}
