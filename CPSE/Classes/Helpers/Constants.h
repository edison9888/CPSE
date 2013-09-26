//#define kUMengAppKey @"52400b8356240bcf3906ba13"  // CPSE account
#define kUMengAppKey @"51da572256240bcbf201f9d0"  // dev account

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