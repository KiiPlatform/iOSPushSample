'''
Created on 2013/02/21
@author: Ryuji OCHI
Copyright (c) 2013 Kii Corporation. All rights reserved.
'''
import setup_push
import sys

if __name__ == '__main__':
    helper = setup_push.ApiHelper()
    helper.createAppBucketObjectDebug(sys.argv[1])
