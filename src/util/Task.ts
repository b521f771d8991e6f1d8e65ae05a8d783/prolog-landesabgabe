export enum TaskStatus {
	NOT_STARTED, // TODO check if needed
	UPLOADING = "UPLOADING", // TODO check if needed
	PENDING = "PENDING",
	PROGRESS = "PROGRESS",
	SUCCESS = "SUCCESS",
	FAILURE = "FAILURE",
	ABORTED = "ABORTED",
	FINISHED = "FINISHED",
}

export function isTaskProcessing(status: TaskStatus): boolean {
	return status === TaskStatus.PENDING || status === TaskStatus.PROGRESS;
}

export function isTaskFinished(status: TaskStatus): boolean {
	return (
		status === TaskStatus.FAILURE ||
		status === TaskStatus.SUCCESS ||
		status == TaskStatus.ABORTED
	);
}

export function isTaskSuccessful(status: TaskStatus): boolean {
	return status === TaskStatus.SUCCESS;
}
export function isTaskErronous(status: TaskStatus): boolean {
	return status === TaskStatus.FAILURE || status == TaskStatus.ABORTED;
}

export enum TaskName {
	MSG_PROPOSAL_GEN = "nlp_workers.generate_mail_proposal",
	SUMMARIZE_ATTACHMENT = "nlp_workers.summarize_attachments",
}

export interface TaskResult {
	task_id: string;
	status: TaskStatus;
	result: string;
	score: number;
	sourceLanguage: string;
	targetLanguage: string;
}
