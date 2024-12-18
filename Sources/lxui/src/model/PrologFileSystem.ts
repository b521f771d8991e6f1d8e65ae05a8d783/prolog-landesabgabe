// this should be done in the backend

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

export class PrologFile {
    public name: string;
    public content: string;

    constructor(name: string, content: string) {
        this.name = name;
        this.content = content;
    }
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
