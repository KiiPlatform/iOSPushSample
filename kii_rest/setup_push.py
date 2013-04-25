'''
Created on 2013/02/21
@author: Ryuji OCHI
Copyright (c) 2013 Kii Corporation. All rights reserved.
'''
import ConfigParser
import logging
import httplib
import json
import time

CONFIG_FILE = 'setting.ini'

def getLogger():
    logger = logging.getLogger('debug')
    ch = logging.StreamHandler();
    ch.setLevel(logging.DEBUG)
    logger.addHandler(ch)
    logger.setLevel(logging.DEBUG)
    return logger

class ApiHelper(object):

    def __init__(self):
        conf = ConfigParser.SafeConfigParser()
        conf.read(CONFIG_FILE)
        self.appId = conf.get('app', 'app-id')
        self.appKey = conf.get('app', 'app-key')
        self.clientId = conf.get('app', 'client-id')
        self.clientSecret = conf.get('app', 'client-secret')
        self.host = conf.get('app', 'host')
        self.apnsCertDevOnly = conf.get('app', 'apns-cert-dev-only')
        self.apnsDevCertName = conf.get('app', 'apns-dev-cert-name')
        self.apnsDevCertPass = conf.get('app', 'apns-dev-cert-pass')
        self.apnsProductionCertName = conf.get('app', 'apns-production-cert-name')
        self.apnsProductionCertPass = conf.get('app', 'apns-production-cert-pass')
        self.appTopic = conf.get('constants', 'app-topic-name')
        self.appBucket= conf.get('constants', 'app-bucket-name')
        self.message = conf.get('constants', 'push-message')
        self.logger = getLogger()
        self.logger.debug('app id: ' + self.appId)
        self.logger.debug('app key: ' + self.appKey)
        self.logger.debug('base uri: ' + self.host)
        self.logger.debug('client id: ' + self.clientId)
        self.logger.debug('client secret: ' + self.clientSecret)
        self.logger.debug('APNS cert dev only: ' + self.apnsCertDevOnly)
        self.logger.debug('APNS dev cert name: ' + self.apnsDevCertName)
        self.logger.debug('APNS dev cert pass: ' + self.apnsDevCertPass)
        self.logger.debug('APNS production cert name: ' + self.apnsProductionCertName)
        self.logger.debug('APNS production cert pass: ' + self.apnsProductionCertPass)
        self.logger.debug('app topic name: ' + self.appTopic)
        self.logger.debug('app bucket name: ' + self.appBucket)
        self.logger.debug('push message: ' + self.message)
        self.getAppAdminToken()

    def setAPNSDevCertificate(self):
        self.logger.debug('Set APNS Dev certificate')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/development-certificate'.format(self.appId);
        self.logger.debug('path: ' + path)
        body = open(self.apnsDevCertName, "rb")
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token,
                   'content-type': 'application/x-pkcs12'}
        conn.request('PUT', path, body, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', response.read())

    def removeAPNSDevCertificate(self):
        self.logger.debug('Remove APNS Dev certificate')
        conn = httplib.HTTPSConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/development-certificate'.format(self.appId);
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token}
        conn.request('DELETE', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def setAPNSDevPassword(self):
        self.logger.debug('Set APNS Dev password')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/development-password'.format(self.appId);
        self.logger.debug('path: ' + path)
        body = self.apnsDevCertPass
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token,
                   'content-type': 'text/plain'}
        conn.request('PUT', path, body, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', response.read())

    def removeAPNSDevPassword(self):
        self.logger.debug('Remove APNS Dev password')
        conn = httplib.HTTPSConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/development-password'.format(self.appId);
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token}
        conn.request('DELETE', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def setAPNSProductionCertificate(self):
        self.logger.debug('Set APNS Production certificate')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/production-certificate'.format(self.appId);
        self.logger.debug('path: ' + path)
        body = open(self.apnsProductionCertName, "rb")
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token,
                   'content-type': 'application/x-pkcs12'}
        conn.request('PUT', path, body, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', response.read())

    def removeAPNSProductionCertificate(self):
        self.logger.debug('Remove APNS Production certificate')
        conn = httplib.HTTPSConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/production-certificate'.format(self.appId);
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token}
        conn.request('DELETE', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def setAPNSProductionPassword(self):
        self.logger.debug('Set APNS Production password')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/production-password'.format(self.appId);
        self.logger.debug('path: ' + path)
        body = self.apnsProductionCertPass
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token,
                   'content-type': 'text/plain'}
        conn.request('PUT', path, body, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', response.read())

    def removeAPNSProductionPassword(self):
        self.logger.debug('Remove APNS Production password')
        conn = httplib.HTTPSConnection(self.host)
        path = '/api/apps/{0}/configuration/apns/production-password'.format(self.appId);
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                   'authorization': 'Bearer ' + self.token}
        conn.request('DELETE', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def getAppAdminToken(self):
        self.logger.debug('get token')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/oauth2/token'
        body = {'client_id': self.clientId, 'client_secret': self.clientSecret}
        jsonBody = json.dumps(body)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                'content-type': 'application/json'}
        conn.request('POST', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', respDict)
        token = respDict['access_token']
        self.logger.debug('access-token: ' + token)
        self.token = token

    def createAppTopic(self):
        self.logger.debug('create app topic')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/topics/{1}'.format(self.appId, self.appTopic)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-length'] = 0
        self.logger.debug('path: %s', path)
        conn.request('PUT', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def grantSubscriptionOfAppTopic(self):
        self.logger.debug('create app topic')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/topics/{1}/acl/SUBSCRIBE_TO_TOPIC/UserID:ANY_AUTHENTICATED_USER'\
            .format(self.appId, self.appTopic)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-length'] = 0
        self.logger.debug("path: %s", path)
        conn.request('PUT', path, None, headers)
        response = conn.getresponse()
        self.logger.debug('status: %d', response.status)

    def sendMessageToAppTopic(self):
        self.logger.debug('send message to app topic')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/topics/{1}/push/messages'\
            .format(self.appId, self.appTopic)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] =\
            'application/vnd.kii.SendPushMessageRequest+json'
        pushData = {'hello app topic push': self.message}
        gcm = {'enabled': True}
        apns = {'enabled': True}
        body = {'data': pushData, 'gcm': gcm, 'apns': apns}
        jsonBody = json.dumps(body)
        self.logger.debug('path: %s', path)
        self.logger.debug('data %s', jsonBody)
        conn.request('POST', path, jsonBody, headers)
        response = conn.getresponse()
        self.logger.debug("status: %d", response.status)
        self.logger.debug("body: %s", json.load(response))

    def createAppBucketObject(self):
        self.logger.debug('create app bucket')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/buckets/{1}/objects'\
            .format(self.appId, self.appBucket)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/json'
        obj = {'hoge':'dummy'}
        jsonObj = json.dumps(obj)
        self.logger.debug('path: %s', path)
        self.logger.debug('data %s', jsonObj)
        conn.request('POST', path, jsonObj, headers)
        response = conn.getresponse()
        self.logger.debug("status: %d", response.status)
        self.logger.debug("body: %s", json.load(response))

    def sendMessageToAppTopicDebug(self, filename):
        self.logger.debug('send message to app topic')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/topics/{1}/push/messages'\
            .format(self.appId, self.appTopic)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] =\
            'application/vnd.kii.SendPushMessageRequest+json'
        gcm = {'enabled': True}
        apns = {'enabled': True}
        currenttime = int(time.time() * 1000)
        pushData = {'hello app topic push': self.message, 'time': currenttime, 'perf': True}
        body = {'data': pushData, 'gcm': gcm, 'apns': apns}
        jsonBody = json.dumps(body)
        self.logger.debug('path: %s', path)
        self.logger.debug('data %s', jsonBody)
        conn.request('POST', path, jsonBody, headers)
        response = conn.getresponse()
        self.logger.debug("status: %d", response.status)
        self.logger.debug("body: %s", json.load(response))
        self.writeToFile(filename, str(currenttime), str(response.status))

    def createAppBucketObjectDebug(self, filename):
        self.logger.debug('create app bucket')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/buckets/{1}/objects'\
            .format(self.appId, self.appBucket)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/json'
        currenttime = int(time.time() * 1000)
        obj = {'hoge':'dummy', 'time': currenttime, 'perf': True}
        jsonObj = json.dumps(obj)
        self.logger.debug('path: %s', path)
        self.logger.debug('data %s', jsonObj)
        conn.request('POST', path, jsonObj, headers)
        response = conn.getresponse()
        self.logger.debug("status: %d", response.status)
        dictionary = json.load(response)
        self.logger.debug("body: %s", dictionary)
        self.writeToFile(filename, dictionary['objectID'], str(response.status))

    def apnsCertDevOnlyMode(self):
        return self.apnsCertDevOnly

    def writeToFile(self, filename, contents, statusCode):
        f = open(filename, 'a')
        f.write(contents + '\t' + statusCode + '\n')
        f.close()

if __name__ == '__main__':
    helper = ApiHelper()
    helper.removeAPNSDevCertificate()
    helper.setAPNSDevCertificate()
    helper.removeAPNSDevPassword()
    helper.setAPNSDevPassword()
    if helper.apnsCertDevOnlyMode() != '1':
        helper.removeAPNSProductionCertificate()
        helper.setAPNSProductionCertificate()
        helper.removeAPNSProductionPassword()
        helper.setAPNSProductionPassword()
    helper.createAppTopic()
    helper.grantSubscriptionOfAppTopic()
    helper.createAppBucketObject()

