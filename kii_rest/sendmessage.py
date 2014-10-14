'''
Created on 2013/02/21
@author: Ryuji OCHI
Copyright (c) 2013 Kii Corporation. All rights reserved.
'''
import setup_push
import sys
import argparse
import httplib
import time
import json

def sendMessageToAppTopicDebug(helper, filename):
    helper.logger.debug('send message to app topic')
    path = '/api/apps/{0}/topics/{1}/push/messages'\
        .format(helper.appId, helper.appTopic)
    sendTopicMessage(helper, path, filename)

def sendMessageToUserTopicDebug(helper, userid, filename):
    helper.logger.debug('send message to user topic')
    path = '/api/apps/{0}/users/{1}/topics/{2}/push/messages'\
            .format(helper.appId, userid, helper.userTopic)
    sendTopicMessage(helper, path, filename)

def sendTopicMessage(helper, path, filename):
    helper.logger.debug('Target path : ' + path)
    conn = httplib.HTTPConnection(helper.host)
    headers = {'x-kii-appid': helper.appId, 'x-kii-appkey': helper.appKey}
    headers['authorization'] = 'Bearer ' + helper.token
    headers['content-type'] =\
            'application/vnd.kii.SendPushMessageRequest+json'
    currenttime = int(time.time() * 1000)
    gcm = {'enabled': True}
    alert = {'body' : "Invitations "}
    contentAvailable = False
    if helper.contentAvailable == "1":
        contentAvailable = True
    apns = {'enabled': True, 'contentAvailable': contentAvailable,"category":"INVITE_CATEGORY", 'alert': alert}
    pushData = {'pushdata': helper.message}
    body = {'data': pushData, 'gcm': gcm, 'apns': apns}
    jsonBody = json.dumps(body)
    helper.logger.debug('path: %s', path)
    helper.logger.debug('data %s', jsonBody)
    conn.request('POST', path, jsonBody, headers)
    response = conn.getresponse()
    responseBody = json.load(response)
    helper.logger.debug("status: %d", response.status)
    helper.logger.debug("body: %s", responseBody)
    if filename is not None:
        writeToFile(filename, str(currenttime), str(response.status), str(responseBody['pushMessageID']))

def writeToFile(filename, contents, statusCode, pushMessageID):
    f = open(filename, 'a')
    f.write(contents + '\t' + statusCode + '\t' + pushMessageID + '\n')
    f.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--userid', nargs='?', default=None, help='UserID to send message')
    parser.add_argument('--logfile', nargs='?', default=None, help='File name to save logs')
    parser.add_argument('--topic', choices=['app', 'user'], help='Target topic to send message', required=True)
    args = parser.parse_args()

    helper = setup_push.ApiHelper()
    if args.topic == 'app':
        sendMessageToAppTopicDebug(helper, args.logfile)
    elif args.topic == 'user':
        if args.userid == None:
            helper.logger.debug('UserID is required')
            sys.exit()
        sendMessageToUserTopicDebug(helper, args.userid, args.logfile)

