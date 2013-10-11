//
//  Result.h
//  PotatoBattle-coco
//
//  Created by pspencil on 16/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayScene.h"
#import "HelloWorldLayer.h"
@interface Result : CCLayerColor {
    
}
+ (CCScene*) sceneWithWords: (NSString*) words;
@end
