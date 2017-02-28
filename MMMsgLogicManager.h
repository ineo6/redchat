@class BaseMsgContentLogicController, NSMutableArray, NSString;

@interface MMMsgLogicManager : NSObject
{
    NSMutableArray *_arrLogicControllers;
    BaseMsgContentLogicController *_topLogicController;
    BaseMsgContentLogicController *_weixinLogicController;
    BaseMsgContentLogicController *_roomLogicController;
    BaseMsgContentLogicController *_lastPeekController;
}

//- (void).cxx_destruct;
- (void)finishedPeekingWithController:(id)arg1;
- (id)logicControllerForPeekingWithContact:(id)arg1 messageWrap:(id)arg2;
- (id)GetCurrentLogicController;
- (void)PopLogicController:(id)arg1 withReuse:(BOOL)arg2;
- (void)PopLogicController:(id)arg1;
//- (void)PresentMultiSelectLogicControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 onComplete:(CDUnknownBlockType)arg4;
- (void)PushOtherLogicController:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3;
- (void)PushNewLogicController:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 jumpToLocationNode:(id)arg4;
- (void)PushSearchLogicControllerWithToolBarByContact:(id)arg1 navigationController:(id)arg2 ForMessageWrap:(id)arg3 animated:(BOOL)arg4;
- (void)PushSearchLogicControllerByContact:(id)arg1 navigationController:(id)arg2 ForMessageWrap:(id)arg3 animated:(BOOL)arg4 fromeScene:(int)arg5;
- (void)PushOtherBaseMsgControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 extraInfo:(id)arg4;
- (void)PushOtherBaseMsgControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 searchScene:(int)arg4;
- (void)PushOtherBaseMsgControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3;
- (void)PushLBSRoomLogicControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3;
- (void)PushLogicControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 jumpToLocationNode:(id)arg4 reuse:(BOOL)arg5 extraInfo:(id)arg6;
- (void)cleanUnuseLogicController;
- (void)PushLogicControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 jumpToLocationNode:(id)arg4 reuse:(BOOL)arg5;
- (void)PushLogicControllerByContact:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3 jumpToLocationNode:(id)arg4;
- (void)PushLogicController:(id)arg1 navigationController:(id)arg2 animated:(BOOL)arg3;
- (id)GetReuseableLogicControllerFromCacheWithContact:(Class)arg1;
- (id)GetLogicControllerFromCacheWithContact:(id)arg1;
- (void)setMsgLogicToCache:(id)arg1;
- (Class)GetLogicClassByContact:(id)arg1;
- (BOOL)onServiceMemoryWarning;
- (void)onPluginsChanged:(id)arg1;
- (void)onDeleteSession:(unsigned long)arg1;
- (void)onModifyContact:(id)arg1;
- (void)onDeleteContact:(id)arg1;
- (void)onFontSizeChange;
- (void)onLanguageChange;
- (void)onServiceReloadData;
- (void)CheckIfTopViewControllerPoped;
- (void)cleanUpLogicByName:(id)arg1;
- (void)cleanUp;
- (id)getTopLogicController;
- (void)dealloc;
- (void)onServiceInit;
@property(retain, nonatomic) BaseMsgContentLogicController *topLogicController;
@property(retain, nonatomic) NSMutableArray *arrLogicControllers;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned int hash;
@property(readonly) Class superclass;

@end