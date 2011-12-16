#import "SparklerTextFieldCell.h"

@implementation SparklerTextFieldCell

- (void)drawInteriorWithFrame: (NSRect)frame inView: (NSView *)controlView {
    NSSize contentSize = [self cellSize];
    
    frame.origin.y += (frame.size.height - contentSize.height) / 2.0;
    frame.origin.x += 5;
    frame.size.height = contentSize.height;
    
    [super drawInteriorWithFrame: frame inView: controlView];
}

@end
