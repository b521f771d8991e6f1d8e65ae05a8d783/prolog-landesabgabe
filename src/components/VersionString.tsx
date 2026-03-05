import { Text } from "@mantine/core";

export function VersionString({
	successFormat = "dimmed",
	prefix = "Version: ",
}: {
	successFormat?: string;
	prefix?: string;
}) {
	return (
		<Text c={successFormat}>
			{prefix}Frontend
		</Text>
	);
}
