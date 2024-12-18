// this should be done in the backend

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

interface File {
    name: string;
    content: string;
}

export const defaultFileSet: [URL] = [labbgPl];

export async function getRechtsbestand(fileSet: URL[] = defaultFileSet): Promise<File[]> {
    return Promise.all(fileSet.map(async (url: URL): Promise<File> => {
        const response = await fetch(url);
        return {
            name: url.pathname,
            content: await response.text()
        }
    }));
}
