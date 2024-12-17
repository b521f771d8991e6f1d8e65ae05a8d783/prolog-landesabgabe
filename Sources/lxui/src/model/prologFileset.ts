// this should be done in the backend

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

export const defaultFileSet: [URL] = [labbgPl];

export async function getRechtsbestand(fileSet: URL[] = defaultFileSet): Promise<string> {
    const fetchData: string[] = await Promise.all(fileSet.map(async (url: URL) => {
        const response = await fetch(url);
        return await response.text();
    }));

    return fetchData.reduce((previous: string, current: string) => `${previous}\n${current}`, "");
}
