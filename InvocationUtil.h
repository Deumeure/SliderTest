/*
 *  InvocationUtil.h
 *  book
 *
 *  Created by deumeure tepue on 4/3/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


/*
#define createInvocation(NAME,TARGET,SELECTOR) [NAME release];\
NSMethodSignature *aSignature;\
aSignature = [TARGET.class instanceMethodSignatureForSelector:SELECTOR];\
NAME = [[NSInvocation invocationWithMethodSignature:aSignature] retain];\
[NAME setSelector:SELECTOR];\
[NAME setTarget:TARGET];
*/

#define createInvocation(TARGET,SELECTOR)  [InvocationUtil createInvocation:TARGET	AndSelector:SELECTOR]

#define invoke(NAME)[NAME invoke];

#define invoke1(NAME,ARG1){[NAME setArgument:&ARG1 atIndex:2]; \
[NAME invoke];}

#define invoke2(NAME,ARG1,ARG2){[NAME setArgument:&ARG1 atIndex:2]; \
[NAME setArgument:&ARG2 atIndex:3]; \
[NAME invoke];}

#define invoke3(NAME,ARG1,ARG2,ARG3){[NAME setArgument:&ARG1 atIndex:2]; \
[NAME setArgument:&ARG2 atIndex:3]; \
[NAME setArgument:&ARG3 atIndex:4]; \
[NAME invoke];}

#define invoke4(NAME,ARG1,ARG2,ARG3,ARG4){[NAME setArgument:&ARG1 atIndex:2]; \
[NAME setArgument:&ARG2 atIndex:3]; \
[NAME setArgument:&ARG3 atIndex:4]; \
[NAME setArgument:&ARG4 atIndex:5]; \
[NAME invoke];}

#define invoke5(NAME,ARG1,ARG2,ARG3,ARG4,ARG5){[NAME setArgument:&ARG1 atIndex:2]; \
[NAME setArgument:&ARG2 atIndex:3]; \
[NAME setArgument:&ARG3 atIndex:4]; \
[NAME setArgument:&ARG4 atIndex:5]; \
[NAME setArgument:&ARG5 atIndex:6]; \
[NAME invoke];}

#define invokeWS(NAME,SENDER)[NAME setArgument:&SENDER atIndex:2]; \
[NAME invoke];


#define invokeWS1(NAME,SENDER,ARG1)[NAME setArgument:&SENDER atIndex:2]; \
[NAME setArgument:&ARG1 atIndex:3]; \
[NAME invoke];

#define invokeWS2(NAME,SENDER,ARG1,ARG2)[NAME setArgument:&SENDER atIndex:2]; \
[NAME setArgument:&ARG1 atIndex:3]; \
[NAME setArgument:&ARG2 atIndex:4]; \
[NAME invoke];


#define invokeWS3(NAME,SENDER,ARG1,ARG2,ARG3)[NAME setArgument:&SENDER atIndex:2]; \
[NAME setArgument:&ARG1 atIndex:3]; \
[NAME setArgument:&ARG2 atIndex:4]; \
[NAME setArgument:&ARG3 atIndex:5]; \
[NAME invoke];


#define invokeWS4(NAME,SENDER,ARG1,ARG2,ARG3,ARG4)[NAME setArgument:&SENDER atIndex:2]; \
[NAME setArgument:&ARG1 atIndex:3]; \
[NAME setArgument:&ARG2 atIndex:4]; \
[NAME setArgument:&ARG3 atIndex:5]; \
[NAME setArgument:&ARG4 atIndex:6]; \
[NAME invoke];



#import <Foundation/Foundation.h>


@interface InvocationUtil : NSObject {
	
}
	+(NSInvocation*)createInvocation:(NSObject*)pTarget AndSelector:(SEL)pSelector;

@end
