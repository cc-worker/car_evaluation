from django.test import TestCase

# Create your tests here.


if __name__ == '__main__':
    import urllib2

    sUrl = 'http://www.163.com'
    sock = urllib2.urlopen(sUrl)
    print(sock.headers.values())