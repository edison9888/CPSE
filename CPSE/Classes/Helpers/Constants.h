#define kUMengAppKey @"52400b8356240bcf3906ba13"

#define kBannerHeight 185
#define kAccountChangeNotification @"kAccountChangeNotification"


static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}