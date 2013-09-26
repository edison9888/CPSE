typedef NS_ENUM(NSUInteger, VenueType){
	VenueTypeNone               = 0,
    VenueType1                  = 1,
    VenueType6                  = 2,
    VenueType2                  = 3,
    VenueType3and4              = 4,
    VenueType5                  = 5,
    VenueType7and8              = 6,
    VenueType9                  = 7,
    VenueTypeGroundOn2ndFloor   = 8,
    VenueType5On2ndFloor        = 9,
    VenueType6On2ndFloor        = 10
};

typedef NS_ENUM(NSUInteger, AdUriType){
    AdUriTypeExhibitorId        = 0,
    AdUriTypeExhibitorUrl       = 1
};

typedef NS_ENUM(NSUInteger, EventType){
    EventTypeSpeech             = 0,
    EventTypeOfficial           = 1
};

typedef NS_ENUM(NSUInteger, FavoriteType){
    FavoriteTypeNewsCPSE        = 0,
    FavoriteTypeNewsIndustry    = 1,
    FavoriteTypeExhibitor       = 2
};