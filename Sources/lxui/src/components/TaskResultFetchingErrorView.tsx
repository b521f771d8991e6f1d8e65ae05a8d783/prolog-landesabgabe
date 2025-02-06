import { Paper, Text } from "@mantine/core";

export const TaskResultFetchingErrorView = () => {
  return (
    <>
      <Paper shadow="sm" p="xl" m="sm">
        <Text>
          Fehler: Norm konnte nicht generiert werden. Überprüfen Sie bitte Ihre Auswahl. 
          Sollte der Fehler bestehen, wenden Sie sich bitte an die Zuständigen
        </Text>
      </Paper>
    </>
  );
};
