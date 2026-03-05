import { Box, Button, LoadingOverlay, Paper, Text } from "@mantine/core";
// import { usePostTaskStatusRequest } from '@/util/BackendQueryProvider';
import {
	isTaskErronous,
	isTaskProcessing,
	isTaskSuccessful,
} from "@/util/Task";
import { useQueryClient } from "@tanstack/react-query";

interface TaskResultViewProps {
	taskId: string;
	addNorm: (norm: string) => void;
}

export const TaskResultView = ({ taskId, addNorm }: TaskResultViewProps) => {
	//const queryClient = useQueryClient();
	//const { data, error, isLoading, isError, isSuccess } = usePostTaskStatusRequest(taskId);
	//
	//const renderTaskResult = () => {
	//  return (
	//    <>
	//      {data &&
	//        (isTaskSuccessful(data.status) ? (
	//          <Text>Norm: {data.result}</Text>
	//        ) : isTaskErronous(data.status) ? (
	//          <Text>
	//            Fehler: Norm konnte nicht generiert werden. Überprüfen Sie bitte Ihre Auswahl. Sollte
	//            der Fehler bestehen, wenden Sie sich bitte an die Zuständigen
	//          </Text>
	//        ) : isTaskProcessing(data.status) ? (
	//          <Text>Norm wird berechnet...</Text>
	//        ) : (
	//          <Text>Unbekannter Fehler - Wenden Sie sich bitte an die Zuständigen</Text>
	//        ))}
	//    </>
	//  );
	//};
	//
	//return (
	//  <>
	//    <Box pos="relative">
	//      <LoadingOverlay
	//        visible={isLoading}
	//        zIndex={1000}
	//        overlayProps={{ radius: 'sm', blur: 2 }}
	//      />
	//      {(isSuccess || isError) && (
	//        <Paper shadow="sm" p="xl" m="sm">
	//          {isSuccess && renderTaskResult()}
	//          {isError && <Text>Error: {error?.message}</Text>}
	//        </Paper>
	//      )}
	//      <Button disabled={!isSuccess || !data} onClick={() => addNorm(data!.result)}>
	//        Norm übernehmen
	//      </Button>
	//    </Box>
	//  </>
	//);
	return <></>;
};
