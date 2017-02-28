#import "CBMessageHud.h"

static UIButton* contentView;



@implementation CBMessageHud

+ (UIButton *)showHUDInView:(UIView *)view text:(NSString *)text target:(id)target action:(SEL)selector
{
    NSLog(@"showHuD === %@", text);
    
    [contentView removeFromSuperview];
    contentView = nil;
    
    contentView = [[UIButton alloc] init];
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    
    [view addSubview:contentView];
    
    [contentView setTitle:text forState:UIControlStateNormal];
    [contentView sizeToFit];
    
    contentView.titleLabel.font=[UIFont systemFontOfSize:14];
    contentView.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    contentView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [contentView addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    contentView.frame = CGRectMake((view.frame.size.width - contentView.bounds.size.width)-15, 84, contentView.bounds.size.width, contentView.bounds.size.height);
    contentView.contentEdgeInsets=UIEdgeInsetsMake(0,10,0,0);
    
    return contentView;
    
}

+ (BOOL)showed
{
    return contentView && contentView.superview;
}


@end
