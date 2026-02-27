/**
 * Determines if the given array represents a "Prolog false" value.
 * In this context, a "Prolog false" is interpreted as an array
 * that contains no truthy values.
 *
 * @param a - The array to evaluate.
 * @returns `true` if the array contains no truthy values, otherwise `false`.
 */
export function isPrologFalse(a: any[]): boolean {
	const filtered = a.filter((v): v is any => !!v);
	return filtered.length === 0;
}

/**
 * Extracts and maps the values associated with a specified key from an array of objects,
 * and casts them to the specified generic type `T`.
 *
 * @template T - The type to which the extracted values will be cast.
 * @param a - An array of objects from which the values will be extracted.
 * @param key - The key whose associated values will be extracted from each object in the array.
 * @returns An array of values of type `T` extracted from the input array.
 */
export function getPrologBinding<T>(a: any[], key: string): T[] {
	console.log("Reading", key, "from", a);
	const anyRet: any[] = a.map((x) => x[key]);
	return anyRet.map((x) => x as T);
}
