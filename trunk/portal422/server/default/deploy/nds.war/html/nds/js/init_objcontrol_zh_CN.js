var NDS_PATH="/html/nds";

var gMessageHolder={
	INTERNAL_ERROR:"\u670d\u52a1\u5668\u5904\u7406\u8bf7\u6c42\u65f6\u9047\u5230\u5f02\u5e38",	
	LOADING:"\u670d\u52a1\u5668\u5904\u7406\u4e2d",
	CATEGORY_GUIDE:"\u5206\u7c7b\u5bfc\u822a",
	MAINTAIN_BY_SYS: "\u7cfb\u7edf\u7ef4\u62a4",
	TIME_OUT:"\u64cd\u4f5c\u8d85\u65f6",
	DO_YOU_CONFIRM_DELETE:"\u4f60\u786e\u8ba4\u8981\u5220\u9664\u6574\u4e2a0(\u82e5\u6709\u660e\u7ec6\u4e5f\u4e00\u5e76\u5220\u9664)\uff1f",
	DO_YOU_CONFIRM_UNSUBMIT:"\u4f60\u786e\u8ba4\u8981\u53d6\u6d88\u63d0\u4ea4\u5417?",
	DO_YOU_CONFIRM_SUBMIT:"\u4f60\u786e\u8ba4\u8981\u6267\u884c\u63d0\u4ea4\u52a8\u4f5c\u5417?",
	DO_YOU_CONFIRM_GROUPSUBMIT:"\u5f53\u524d\u7c7b\u578b\u5bf9\u8c61\u7684\u591a\u884c\u540c\u65f6\u63d0\u4ea4\u5c06\u4ea7\u751f\u6570\u636e\u201c\u5408\u5e76\u201d\u7684\u7279\u6b8a\u529f\u80fd\u3002\\n\\n\u60a8\u786e\u8ba4\u8981\u6267\u884c\u6b64\u7279\u6b8a\u529f\u80fd?\\n\\n\uff08\u9009\u62e9\u201c\u53d6\u6d88\u201d\u5982\u679c\u60a8\u5c1a\u4e0d\u4e86\u89e3\u6240\u8c13\u201c\u5408\u5e76\u201d\u7684\u610f\u4e49\uff0c\u5e76\u67e5\u770b\u6709\u5173\u5e2e\u52a9\u4ee5\u660e\u786e\uff09",
	NO_PERMISSION: "\u6ca1\u6709\u6743\u9650",
	EXCEPTION: "\u5f02\u5e38",
	PLEASE_CHECK_SELECTED_LINES:"\u8bf7\u5728\u8981\u9009\u62e9\u7684\u884c\u9996\u6253\u52fe\u786e\u8ba4\uff01",
	PLEASE_SELECT_LINES_LESS_THAN:"\u8bf7\u9009\u62e9\u5c11\u4e8e20\u884c\u7684\u6570\u636e\uff0c\u4ee5\u4fdd\u8bc1\u5ba2\u6237\u7aef\u54cd\u5e94\u901f\u5ea6\uff01",
	MORE_COMMANDS:"\u66f4\u591a",
	CONFIRM_DELETE_CHECKED:"\u4f60\u786e\u8ba4\u8981\u5220\u9664\u9009\u4e2d\u7684\u884c\uff1f",
	NO_DATA_TO_PROCESS:"\u6ca1\u6709\u9700\u8981\u5904\u7406\u7684\u6570\u636e",
	CAN_NOT_BE_NULL: "\u4e0d\u80fd\u4e3a\u7a7a",
	MUST_BE_DATE_TYPE:"\u5fc5\u987b\u662f\u65e5\u671f\u578b",
	MUST_BE_NUMBER_TYPE: "\u5fc5\u987b\u662f\u6570\u5b57\u578b",
	PLEASE_SELECT: "\u8bf7\u9009\u62e9",
	MAINTAIN_BY_SYS: "\u7cfb\u7edf\u7ef4\u62a4",
	NO_PERMISSION: "\u6ca1\u6709\u8db3\u591f\u7684\u6743\u9650",
	CMD_ADD:"\u65b0\u589e",
	CMD_MODIFY:"\u4fee\u6539",
	CMD_DELETE:"\u5220\u9664",
	CMD_SUBMIT:"\u63d0\u4ea4",
	CMD_REFRESH:"\u5237\u65b0",
	CMD_CXTAB:"\u7edf\u8ba1",
	CMD_LISTADD:"\u6279\u91cf\u65b0\u589e",
	CMD_IMPORT:"\u5bfc\u5165",
	CMD_LISTCOPYTO:"\u590d\u5236",
	CMD_UPDATE_SELECTION:"\u4fee\u6539\u9009\u4e2d\u884c",
	CMD_UPDATE_RESULTSET:"\u4fee\u6539\u7ed3\u679c\u96c6",
	CMD_PRINT_LIST:"\u6253\u5370",
	CMD_EXPORT_LIST:"\u5bfc\u51fa",
	CMD_SMS_LIST:"\u77ed\u4fe1",
	CAN_NOT_QUICK_SEARCH:"\u67e5\u8be2\u5f02\u5e38\uff0c\u8bf7\u5237\u65b0\u5f53\u524d\u7f51\u9875\u540e\u518d\u8bd5",
	CONFIRM_DELETE_CHECKED:"\u4f60\u786e\u8ba4\u5220\u9664\u9009\u62e9\u7684\u884c?",
	NO_DATA_TO_PROCESS:"\u6ca1\u6709\u6570\u636e\u9700\u8981\u5904\u7406",
	CONFIRM_DISCARD_CHANGE: "\u5c1a\u672a\u4fdd\u5b58\u66f4\u6539\uff0c\u4f60\u786e\u8ba4\u8981\u653e\u5f03?",
	DENY_AS_NEW_OBJ:"\u8bf7\u5148\u4fdd\u5b58\uff0c\u7136\u540e\u6267\u884c\u6b64\u64cd\u4f5c",
	SET_PRODUCT_ATTRIBUTE:"\u8bbe\u7f6e\u5c5e\u6027",
	SHOW_ATTRIBUTE:"\u8be6\u7ec6",
	LOAD_ATTRIBUTE:"\u67e5",
	ATTRIBUTE_MATRIX_SPLITTED:"\u5c5e\u6027\u77e9\u9635\u88ab\u62c6\u5206\u4e3a\u591a\u884c\u4fdd\u5b58",
	RELOAD_SINCE_ATTRIBUTE_MATRIX_SPLITTED:"\u6709\u5c5e\u6027\u77e9\u9635\u88ab\u62c6\u5206\u6210\u591a\u884c\uff0c\u662f\u5426\u5237\u65b0\u9875\u9762?",
	NEW_LINE: "\u65b0\u589e\u884c",
	EDIT_LINE: "\u7f16\u8f91\u884c",
	INFORMATION: "\u4fe1\u606f",
	CLOSE_DIALOG:"\u5173\u95ed",
	FINISH_TIME:"\u5b8c\u6210\u65f6\u95f4",
	IFRAME_TITLE:'\u5bf9\u8bdd\u6846 ',
	SEARCH:"\u67e5\u627e",
	NO_DATA:"\u6ca1\u6709\u6570\u636e",
	INPUT_FIELD:"\u8bf7\u9996\u5148\u8f93\u51650\u4fe1\u606f",
	CONTAINS:"\u5305\u542b",
	NOT_ALLOW_TO_POPUP_AS_NOT_MENUOBJ:"\u5f53\u524d\u660e\u7ec6\u884c\u7981\u6b62\u5f39\u51fa\u7a97\u53e3\u663e\u793a",
	CLOSE_DIALOG:"\u5173\u95ed",
	EXCLUDE_CHOOSED_ROWS:"\u6392\u9664\u9009\u4e2d\u884c",
	EXCLUDE_ALL:"\u6392\u9664\u5168\u90e8",
	ADD_CHOOSE_ROWS:"\u6dfb\u52a0\u9009\u4e2d\u884c",
	ADD_ALL:"\u6dfb\u52a0\u5168\u90e8",
	ALREADY_CHOOSED:"\u5df2\u88ab\u9009\u62e9",
	ALREADY_EXCLUDE:"\u5df2\u88ab\u6392\u9664",
	SET_ALREADY_CHOOSED:"\u8be5\u96c6\u5408\u5df2\u88ab\u9009\u62e9",
	SET_ALREADY_EXCLUDE:"\u8be5\u96c6\u5408\u5df2\u88ab\u6392\u9664",
	CONFIRM_SAVE_FIRST: "\u6709\u6570\u636e\u6539\u52a8\uff0c\u5148\u4fdd\u5b58\u6539\u52a8?",
	AVAILABLE:"(\u53ef\u7528 = Y)",
	CLOSE_AFTER_PRINT:"\u8bf7\u5728\u6253\u5370\u5b8c\u6210\u540e\uff0c\u70b9\u51fb'\u786e\u5b9a'\u6309\u94ae\u5173\u95ed\u5f53\u524d\u7a97\u53e3",
	NOT_INTEGER:"\u60a8\u8f93\u5165\u7684\u6570\u5b57\u4e0d\u662f\u6574\u6570",
	PRODUCT_NMNER_ZORE:"\u5546\u54c1\u7684\u6570\u91cf\u4e3a0!",
	LINE:"\u884c",
	TURBO_SCAN:"\u6025\u901f\u626b\u63cf",
	SCAN_ERROR:"\u626b\u63cf\u6761\u7801\u65f6\u53d1\u73b0\u5f02\u5e38:x\u3002\u8bf7\u8f93\u51650\u5173\u95ed\u5f53\u524d\u63d0\u793a(\u5df2\u7d2f\u8ba1\u9519\u8befy\u6b21)",
	PROCESS_ING:"\u8bf7\u5728\u670d\u52a1\u5668\u5904\u7406\u5b8c\u6210\u540e\u518d\u8f93\u5165"
};
