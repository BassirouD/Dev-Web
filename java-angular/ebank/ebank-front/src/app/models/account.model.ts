import {accountOperation} from "./accountOperation.model";

export interface AccountDetails {
    accountId: string;
    balance: number;
    currentPage: number;
    totalPages: number;
    pageSize: number;
    accountHistoryDTOS: accountOperation[];
}
