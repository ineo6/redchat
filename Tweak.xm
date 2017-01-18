#import "WeChatRedEnvelop.h"

%hook CMessageMgr
- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
	%orig;
	
	switch(wrap.m_uiMessageType) {
	case 49: { // AppNode

		CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
		CContact *selfContact = [contactManager getSelfContact];

		BOOL isMesasgeFromMe = NO;
		if ([wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
			isMesasgeFromMe = YES;
		}

		if ([wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) { // 红包
			
			// 是否打开红包开关
			BOOL redEnvelopSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"NXWeChatRedEnvelopSwitchKey"];

			// 群聊中，别人发红包
			BOOL redEnvelopInChatRoomFromOther = ([wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound);
			
			// 群聊中，自己发红包
			BOOL redEnvelopInChatRoomFromMe = (isMesasgeFromMe && ([wrap.m_nsToUsr rangeOfString:@"@chatroom"].location != NSNotFound));

			if (redEnvelopSwitchOn && (redEnvelopInChatRoomFromOther || redEnvelopInChatRoomFromMe)) {

				NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
				nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];

				NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];

				/** 构造参数 */
				NSMutableDictionary *params = [@{} mutableCopy];
				params[@"msgType"] = nativeUrlDict[@"msgtype"] ?: @"1";
				params[@"sendId"] = nativeUrlDict[@"sendid"] ?: @"";
				params[@"channelId"] = nativeUrlDict[@"channelid"] ?: @"1";
				params[@"nickName"] = [selfContact getContactDisplayName] ?: @"";
				params[@"headImg"] = [selfContact m_nsHeadImgUrl] ?: @"";
				params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl] ?: @"";
				params[@"sessionUserName"] = redEnvelopInChatRoomFromMe ? wrap.m_nsToUsr : wrap.m_nsFromUsr;

				NSInteger delaySeconds = [[NSUserDefaults standardUserDefaults] integerForKey:@"NXDelaySecondsKey"];
	
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
					[logicMgr OpenRedEnvelopesRequest:params];
				});
			}
		}	
		break;
	}
	default:
		break;
	}
	
}
%end


%hook CMessageMgr
- (void)DelMsg:(id)arg1 MsgList:(id)arg2 DelAll:(_Bool)arg3{
    %log;
}
- (void)DelMsg:(id)arg1 MsgWrap:(id)arg2{
    %log;
}
%end

%hook CMessageWrap
- (NSString *)m_nsContent{
    NSString *content = %orig;
    if ([content rangeOfString:@"撤回了一条消息"].length > 0){
        NSArray *strings = @[
            @", 可是被帅气机智的我瞄了一眼",
            @", 但是瞒不过我犀利的双眸",
            @", 都是成年人了, 何必遮遮掩掩呢?",
        ];
        BOOL isExistsText = NO;
        for (NSString *string in strings) {
            if ([content rangeOfString:string].length != 0) {
                isExistsText = YES;
                break;
            }
        }
        if (!isExistsText){
            content = [content stringByAppendingString:strings[arc4random_uniform(strings.count)]];
        }
    }
    return content;
}
%end

%hook NewSettingViewController

- (void)reloadTableData {
	%orig;

	MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");

	MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
	
	BOOL redEnvelopSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"NXWeChatRedEnvelopSwitchKey"];
	NSInteger delaySeconds = [[NSUserDefaults standardUserDefaults] integerForKey:@"NXDelaySecondsKey"];

	MMTableViewCellInfo *cellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchRedEnvelop:) target:self title:@"自动抢红包" on:redEnvelopSwitchOn];
	NSString *delaySecondsString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%ld 秒", (long)delaySeconds];
	NSInteger accessoryType = 1;

	MMTableViewCellInfo *delayCellInfo;
	if (!redEnvelopSwitchOn) {
		delayCellInfo = [%c(MMTableViewCellInfo) normalCellForTitle:@"随机延迟" rightValue:@"自动抢红包已关闭"];
	} else {
		delayCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(settingDelay) target:self title:@"随机延迟" rightValue:delaySecondsString accessoryType:accessoryType];
	}


	[sectionInfo addCell:cellInfo];
	[sectionInfo addCell:delayCellInfo];

	[tableViewInfo insertSection:sectionInfo At:0];	

	MMTableView *tableView = [tableViewInfo getTableView];
	[tableView reloadData];
}

%new
- (void)switchRedEnvelop:(UISwitch *)envelopSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setBool:envelopSwitch.on forKey:@"NXWeChatRedEnvelopSwitchKey"];

    [self reloadTableData];
}

%new 
- (void)settingDelay {
	UIAlertView *alert = [UIAlertView new];
    alert.title = @"随机延迟(秒)";
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    
    [alert textFieldAtIndex:0].placeholder = @"延迟时长";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
    	NSString *delaySecondsString = [alertView textFieldAtIndex:0].text;
    	NSInteger delaySeconds = [delaySecondsString integerValue];

    	[[NSUserDefaults standardUserDefaults] setInteger:delaySeconds forKey:@"NXDelaySecondsKey"];

    	[self reloadTableData];
    }
}


%end
