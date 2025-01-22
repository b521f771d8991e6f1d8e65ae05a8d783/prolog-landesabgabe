import { TaskResult, TaskStatus } from "@/util/RestService"
import { Text, Paper } from "@mantine/core"
import { UseQueryResult } from "@tanstack/react-query"

export const TaskResultView = ({ data, error, isLoading, isError, isSuccess }: UseQueryResult<TaskResult, Error>) => {
    return <Paper shadow="sm" p="xl" m="sm">
            {isLoading || data!.status === TaskStatus.PENDING || data!.status === TaskStatus.PROGRESS} ? <Text>Loading ...</Text>
            : {isSuccess} ? <Text>Norm: {data?.result}</Text>
            : {isError} ? <Text>Error: {error?.message}</Text>
            : <Text> Unknown Error :/</Text>
        </Paper>;
}
