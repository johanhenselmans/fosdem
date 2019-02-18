//
//  RoomData.h
//  fosdem
//
//  Created by Johan Henselmans on 17/02/2019.
//  Purpose of RoomData is to have a history of occupancy so that
//  future plaaning can be enhanced
//

#ifndef RoomData_h
#define RoomData_h



#endif /* RoomData_h */

@interface RoomData : NSObject {

    NSString *identifier;
    NSString *title;
    NSMutableArray *speakers;
    NSString *location;
    NSDate *measureDate;
    BOOL occupied;
}
//- (NSMutableDictionary *) userData;

@property (retain) NSString *identifier;
@property (retain) NSString *title;
@property (retain) NSMutableArray *speakers;
@property (retain) NSString *location;

@property (retain) NSDate *measureDate;

@property (assign, getter=isOccupied) BOOL occupied;

@end
