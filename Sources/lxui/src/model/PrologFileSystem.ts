// this should be done in the backend

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

export interface PrologFile {
    name: string;
    content: string;
}

export const defaultFileSet: [URL] = [labbgPl];

export function getRechtsbestand(fileSet: URL[] = defaultFileSet): Promise<PrologFile>[] {
    return fileSet.map(async (url: URL): Promise<PrologFile> => {
        const response = await fetch(url);
        return {
            name: url.pathname,
            content: await response.text()
        }
    });
}
